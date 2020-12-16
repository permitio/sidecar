from fastapi import FastAPI

from horizon.server.api import router as api_router
from horizon.server.middleware import configure_middleware
from horizon.logger import logger
from horizon.policy.updater import policy_updater
from horizon.enforcer.runner import opa_runner

app = FastAPI(title="Horizon Sidecar", version="0.1.0")
configure_middleware(app)

# include the api routes
app.include_router(api_router)

@app.get("/healthcheck", include_in_schema=False)
@app.get("/", include_in_schema=False)
def healthcheck():
    return {"status": "ok"}

@app.on_event("startup")
async def startup_event():
    logger.info("Launching updater thread")
    policy_updater.start()
    logger.info("Launching opa subprocess")
    opa_runner.start()