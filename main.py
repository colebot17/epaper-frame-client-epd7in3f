import asyncio
import websockets
import json
import requests
import io
from PIL import Image
from waveshare_epd import epd7in3f

SERVER_WS = "ws://184.174.134.74:3000"
SERVER_HTTP = "http://184.174.134.74:3000"

RECONNECT_DELAY = 5

async def handle_connection(current_filename, epd):
    async with websockets.connect(
        SERVER_WS,
        ping_interval=20,
        ping_timeout=20
    ) as ws:
        print("Connected to server")
        
        async for msg in ws:
            data = json.loads(msg)
            
            if data["type"] == "update":
                if data["filename"] != current_filename:
                    filename = data["filename"]
                    print("New image:", filename)
                    await update_display(filename, epd)
            elif data["type"] == "clear":
                epd.Clear()
    
    return current_filename

async def update_display(filename, epd):
    try:
        response = requests.get(f"{SERVER_HTTP}/image/{filename}", timeout=10)
        response.raise_for_status()
        
        img = Image.open(io.BytesIO(response.content))
        
        epd.display(epd.getbuffer(img))
        
        print("Display updated")
    
    except Exception as e:
        print("Failed to update image:", e)

async def main():
    current_filename = None
    
    epd = epd7in3f.EPD()
    epd.init()
    epd.Clear()
    
    while True:
        try:
            current_filename = await handle_connection(current_filename, epd)
        except Exception as e:
            print("Connection error:", e)
        
        print(f"Reconnecting in {RECONNECT_DELAY} seconds...")
        await asyncio.sleep(RECONNECT_DELAY)
            
asyncio.run(main())