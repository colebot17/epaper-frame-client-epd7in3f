import asyncio
import websockets
import json
import requests
import io
from PIL import Image
from waveshare_epd import epd7in3f
from wifi import generate_netplan

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
        await sync_image(epd)
        
        async for msg in ws:
            data = json.loads(msg)
            
            if data["type"] == "update":
                if data["filename"] != current_filename:
                    filename = data["filename"]
                    print("New image:", filename)
                    await update_display(filename, epd)
            elif data["type"] == "clear":
                epd.Clear()
            elif data["type"] == "setWifi":
                generate_netplan(data["networks"])
    
    return current_filename

async def update_display(filename, epd):
    try:
        await showServerFile(filename, epd)
    
    except Exception as e:
        print("Failed to update image:", e)
        
async def getServerCurrent():
    res = requests.get(f"{SERVER_HTTP}/current", timeout=10)
    res.raise_for_status()
    j = json.loads(res.content)
    return j.filename
        
async def showServerFile(filename, epd):
    res = requests.get(f"{SERVER_HTTP}/image/{filename}", timeout=10)
    res.raise_for_status()
    
    img = Image.open(io.BytesIO(res.content))
    epd.display(epd.getbuffer(img))
    print("Display updated")
    
    try:
        with open("currentImage.txt", "w") as f:
            f.write(filename)
    except:
        print("Could not save current filename")
        
async def sync_image(epd):
    # load the image from the server if currentImage.txt doesn't match
    try:
        server_image = await getServerCurrent()
        try:
            with open("currentImage.txt", "r") as f:
                currently_displayed = f.read()
                if currently_displayed != server_image:
                    await showServerFile(server_image, epd)
        except:
            print("Could not get currently displayed image, refreshing anyways")
            try:
                await showServerFile(server_image, epd)
            except Exception as e:
                print("Could not load server's image:", e)
    except Exception as e:
        print("Could not access server's current image:", e)

async def main():
    current_filename = None
    
    epd = epd7in3f.EPD()
    epd.init()
    
    while True:
        try:
            current_filename = await handle_connection(current_filename, epd)
        except Exception as e:
            print("Connection error:", e)
        
        print(f"Reconnecting in {RECONNECT_DELAY} seconds...")
        await asyncio.sleep(RECONNECT_DELAY)
            
asyncio.run(main())