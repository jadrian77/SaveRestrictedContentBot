#Github.com/Vasusen-code

from pyrogram import Client

from telethon.sessions import StringSession
from telethon.sync import TelegramClient

from decouple import config
import logging, time, sys

logging.basicConfig(format='[%(levelname) 5s/%(asctime)s] %(name)s: %(message)s',
                    level=logging.WARNING)

# variables
API_ID = config("API_ID", default=None, cast=int)
API_HASH = config("API_HASH", default=None)
BOT_TOKEN = config("BOT_TOKEN", default=None)
SESSION = config("SESSION", default=None)
FORCESUB = config("FORCESUB", default=None)
AUTH = config("AUTH", default=None, cast=int)

#proxy
PROXY_TYPE = config("PROXY_TYPE", default=None)
PROXY_HOST = config("PROXY_HOST", default=None)
PROXY_PORT = config("PROXY_PORT", default=0, cast=int)
client_proxy = None
TelegramClient_proxy = None
if PROXY_TYPE and PROXY_HOST and PROXY_PORT != 0:
    client_proxy = {
        "scheme": PROXY_TYPE,  
        "hostname": PROXY_HOST,
        "port": PROXY_PORT,
    }
    TelegramClient_proxy = (PROXY_TYPE, PROXY_HOST, PROXY_PORT)

bot = TelegramClient('bot', API_ID, API_HASH, proxy=TelegramClient_proxy).start(bot_token=BOT_TOKEN)

userbot = Client("saverestricted", session_string=SESSION, api_hash=API_HASH, api_id=API_ID, proxy=client_proxy)

try:
    userbot.start()
except BaseException:
    print("Userbot Error ! Have you added SESSION while deploying??")
    sys.exit(1)

Bot = Client(
    "SaveRestricted",
    bot_token=BOT_TOKEN,
    api_id=int(API_ID),
    api_hash=API_HASH,
    proxy=client_proxy
)    

try:
    Bot.start()
except Exception as e:
    print(e)
    sys.exit(1)
