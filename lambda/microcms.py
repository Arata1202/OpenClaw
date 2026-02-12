import json
import os
import urllib.error
import urllib.parse
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


def lambda_handler(event: Any, context: Any) -> dict[str, Any]:
    del context

    service_domain = os.getenv("MICROCMS_SERVICE_DOMAIN", "").strip()
    api_key = os.getenv("MICROCMS_API_KEY", "").strip()
    endpoint = "blog"

    if not service_domain:
        return _json_response(500, {"ok": False, "error": "MICROCMS_SERVICE_DOMAIN is empty"})
    if not api_key:
        return _json_response(500, {"ok": False, "error": "MICROCMS_API_KEY is empty"})

    payload = _parse_payload(event)
    status = "draft"
    if isinstance(event, dict):
        query_params = event.get("queryStringParameters")
        if isinstance(query_params, dict):
            query_status = query_params.get("status")
            if isinstance(query_status, str) and query_status.strip():
                status = query_status.strip()

    payload_status = payload.get("status")
    if status == "draft" and isinstance(payload_status, str) and payload_status.strip():
        status = payload_status.strip()

    content = payload.get("content")
    if content is None:
        content = {k: v for k, v in payload.items() if k not in {"status", "queryStringParameters"}}

    if not isinstance(content, dict) or not content:
        return _json_response(400, {"ok": False, "error": "content object is required"})

    query = urllib.parse.urlencode({"status": status})
    url = f"https://{service_domain}.microcms.io/api/v1/{endpoint}?{query}"

    request_body = json.dumps(content, ensure_ascii=False).encode("utf-8")
    request = urllib.request.Request(
        url=url,
        method="POST",
        data=request_body,
        headers={
            "X-MICROCMS-API-KEY": api_key,
            "Content-Type": "application/json",
        },
    )

    try:
        with urllib.request.urlopen(request, timeout=20) as response:
            raw = response.read().decode("utf-8")
            try:
                upstream_body = json.loads(raw)
            except json.JSONDecodeError:
                upstream_body = {"raw": raw}

            return _json_response(
                response.status,
                {
                    "ok": 200 <= response.status < 300,
                    "status": status,
                    "upstream": upstream_body,
                },
            )
    except urllib.error.HTTPError as error:
        detail = error.read().decode("utf-8", errors="replace")
        return _json_response(
            error.code,
            {"ok": False, "error": "microcms request failed", "detail": detail},
        )
    except urllib.error.URLError as error:
        return _json_response(
            502,
            {"ok": False, "error": "microcms network error", "detail": str(error.reason)},
        )
