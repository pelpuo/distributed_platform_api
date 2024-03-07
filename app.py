from fastapi import FastAPI
import uvicorn
from fastapi.middleware.cors import CORSMiddleware
from Aquila.routers import scenario

app = FastAPI()


app.add_middleware(
    CORSMiddleware,
    allow_origins = ["*"],
    allow_methods = ["*"],
    allow_headers = ["*"]
)

app.include_router(scenario.router)


@app.get("/")
def root():
        return {"Hello":"World"}


if __name__ == '__main__':
    uvicorn.run("app:app",
                host="0.0.0.0",
                port=8432,
                reload=True,
                )