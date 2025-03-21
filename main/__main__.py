import glob
from pathlib import Path
from main.utils import load_plugins
import logging
from main import bot

logging.basicConfig(format='[%(levelname) 5s/%(asctime)s] %(name)s: %(message)s',
                    level=logging.WARNING)

from main.plugins import batch, frontend, helpers, progress, pyroplug, start

#Don't be a thief 
print("Successfully deployed!")
print("By MaheshChauhan • DroneBots")

if __name__ == "__main__":
    bot.run_until_disconnected()
