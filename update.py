import subprocess

def update_ota():
    subprocess.run(["git", "pull"], check=True)
    subprocess.run(["./install.sh"], check=True)
    exit()