import json
import os
import urllib.error
import urllib.request
from typing import Any


def _json_response(status_code: int, payload: dict[str, Any]) -> dict[str, Any]:
    return {
        "statusCode": status_code,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(payload, ensure_ascii=False),
    }


def _parse_payload(event: Any) -> dict[str, Any]:
    if not isinstance(event, dict):
        return {}

    body = event.get("body")
    if isinstance(body, str):
        try:
            decoded = json.loads(body)
            return decoded if isinstance(decoded, dict) else {}
        except json.JSONDecodeError:
            return {}
    if isinstance(body, dict):
        return body

    return event


def _extract_image_data(response_json: dict[str, Any]) -> tuple[str, str]:
    candidates = response_json.get("candidates", [])
    if not candidates:
        raise ValueError("candidates not found")

    parts = candidates[0].get("content", {}).get("parts", [])
    for part in parts:
        inline_data = part.get("inlineData")
        if not isinstance(inline_data, dict):
            continue

        mime_type = inline_data.get("mimeType", "")
        image_base64 = inline_data.get("data", "")
        if isinstance(mime_type, str) and mime_type.startswith("image/") and isinstance(image_base64, str) and image_base64:
            return image_base64, mime_type

    raise ValueError("inline image data not found")


def lambda_handler(event: Any, context: Any) -> dict[str, Any]:
    del context

    api_key = os.getenv("NANOBANANA_API_KEY", "").strip()
    model = os.getenv("NANOBANANA_MODEL", "gemini-3-pro-image-preview").strip()

    if not api_key:
        return _json_response(500, {"ok": False, "error": "NANOBANANA_API_KEY is empty"})
    if not model:
        return _json_response(500, {"ok": False, "error": "NANOBANANA_MODEL is empty"})

    payload = _parse_payload(event)
    prompt = payload.get("prompt")
    if not isinstance(prompt, str) or not prompt.strip():
        return _json_response(
            400,
            {
                "ok": False,
                "error": "prompt is required",
            },
        )

    full_prompt = prompt.strip()
    request_body = json.dumps(
        {"contents": [{"parts": [{"text": full_prompt}]}]},
        ensure_ascii=False,
    ).encode("utf-8")

    request = urllib.request.Request(
        url=f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent",
        method="POST",
        data=request_body,
        headers={
            "x-goog-api-key": api_key,
            "Content-Type": "application/json",
        },
    )

    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            raw = response.read().decode("utf-8")
            response_json = json.loads(raw)

            if "error" in response_json:
                return _json_response(
                    502,
                    {"ok": False, "error": "nanobanana upstream error", "detail": response_json["error"]},
                )

            image_base64, mime_type = _extract_image_data(response_json)
            return _json_response(
                200,
                {
                    "ok": True,
                    "model": model,
                    "mime_type": mime_type,
                    "image_base64": image_base64,
                },
            )
    except urllib.error.HTTPError as error:
        detail = error.read().decode("utf-8", errors="replace")
        return _json_response(
            error.code,
            {"ok": False, "error": "nanobanana request failed", "detail": detail},
        )
    except urllib.error.URLError as error:
        return _json_response(
            502,
            {"ok": False, "error": "nanobanana network error", "detail": str(error.reason)},
        )
    except (ValueError, json.JSONDecodeError) as error:
        return _json_response(
            502,
            {"ok": False, "error": "invalid nanobanana response", "detail": str(error)},
        )
