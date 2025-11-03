# app/utils/api_discover.py
from app.main import app

def discover():
    items = []
    for r in app.routes:
        if hasattr(r, 'methods') and hasattr(r, 'path'):
            for m in sorted((r.methods or [])):
                if m in ("GET","POST","PUT","DELETE","PATCH"):
                    items.append({"method": m, "path": r.path})
    return items

if __name__ == '__main__':
    for it in discover():
        print(it)