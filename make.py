#!/usr/bin/python

"""
Package Builder

Usage:
    make.py install [options]
    make.py test [options]
    make.py server [options]
    make.py build [options]
    make.py publish [options]

Options:
    -h --help               Show this screen
    --version               Show version
    -c --config=<config>    JSON config [default: ~/kf2make.json]
"""

import docopt
import json
import os
import _winreg
import shutil

CONFIG_BASE = {
                'default': 'yeehaw',
                'yeehaw': {
                    'target':r'c:/temp/yeehaw',
                    'icon': 'yeehaw.png',
                    'target_icon': r'c:/temp/yeehaw.png',
                    'workshop': 'yeehaw.txt',
                    'workshop_upload': '"{workshop_fpath}" yeehaw.txt',
                    'target_workshop': '~/Documents/My Games/KillingFloor2/yeehaw.txt',
                    'test': '"{bin_path}/kfeditor.exe" kf-outpost?game=YeeHaw.YH_Survival?difficulty=2 -useunpublished -log',
                    'server_copy': [
                            ['{brew_path}/YeeHaw.u','{server_path}/BrewedPC'],
                        ],
                    'build': '"{bin_path}/kfeditor.exe" brewcontent -platform=PC -log',
                    'workshop_copy': [
                            ['{brew_path}/YeeHaw.u','BrewedPC'],
                        ],
                    }
                }

args = docopt.docopt(__doc__,version="Builder 1.0")

PACKAGE_PATH = "C:/"
CONFIG_FPATH = os.path.expanduser(args['--config'])

INSTALL_KEY = _winreg.OpenKey(_winreg.HKEY_LOCAL_MACHINE,
                            r"SOFTWARE\WOW6432Node\Valve\Steam",
                            0,
                            (_winreg.KEY_WOW64_64KEY + _winreg.KEY_ALL_ACCESS))
STEAM_INSTALL_PATH = _winreg.QueryValueEx(INSTALL_KEY,"InstallPath")[0]
KF2_INSTALL_PATH = STEAM_INSTALL_PATH + r"\steamapps\common\killingfloor2"
KF2_BIN_PATH = KF2_INSTALL_PATH + r"\Binaries\Win64"
KF2_WORKSHOP_FPATH = KF2_INSTALL_PATH + r"\Binaries\WorkshopUserTool.exe"
HOME_PATH = os.path.expanduser("~")
KF2_BREWED_PATH = HOME_PATH+"/Documents/My Games/KillingFloor2/KFGame/Published/BrewedPC"
KF2_SERVER_PATH = r"C:\kf2server\KFGame"

def load_config(config_fpath):
    with open(config_fpath) as f:
        buf = f.read()
    return json.loads(buf)

def amend_config(config_fpath):
    config = load_config(config_fpath)
    config.update(CONFIG_BASE)
    buf = json.dumps(CONFIG_BASE)
    with open(config_fpath,"w") as f:
        f.write(buf)

def create_config(config_fpath):
    buf = json.dumps(CONFIG_BASE)
    with open(config_fpath,"w") as f:
        f.write(buf)

def build_config(config_fpath):
    config = load_config(config_fpath)
    config = config[config['default']]
    return config

# Puts the make.py script in the home directory
if args['install']:
    with open(__file__) as f:
        buf = f.read()

    # Copy over the make file
    with open(os.path.join(HOME_PATH,"make.py"),"w") as f:
        f.write(buf)

    # Create the configuration file
    if os.path.exists(CONFIG_FPATH):
        amend_config(CONFIG_FPATH)
    else:
        create_config(CONFIG_FPATH)

    # Create the build location
    config = build_config(CONFIG_FPATH)
    if not os.path.exists(config['target']):
        os.makedirs(config['target'])

    # Copy the icon
    shutil.copy(config["icon"],config["target_icon"])

    # Copy the workshop upload configuration
    target_workshop = os.path.expanduser(config['target_workshop'])
    shutil.copy(config['workshop'],target_workshop)


elif args['test']:
    config = build_config(CONFIG_FPATH)
    test_execute = config['test'].format(
                            bin_path=KF2_BIN_PATH,
                            install_path=KF2_INSTALL_PATH
                        )
    os.system(test_execute)

elif args['server']:
    config = build_config(CONFIG_FPATH)

    # Copy files into the publish folders
    for src, dest in config['server_copy']:
        src_fpath = src.format(
                            bin_path=KF2_BIN_PATH,
                            install_path=KF2_INSTALL_PATH,
                            brew_path=KF2_BREWED_PATH
                        )
        target_path = dest.format(
                            bin_path=KF2_BIN_PATH,
                            install_path=KF2_INSTALL_PATH,
                            brew_path=KF2_BREWED_PATH,
                            server_path=KF2_SERVER_PATH
                        )

        if not os.path.exists(target_path):
            os.makedirs(target_path)
        shutil.copy(src_fpath,target_path)


elif args['build']:
    config = build_config(CONFIG_FPATH)
    test_execute = config['build'].format(
                            bin_path=KF2_BIN_PATH,
                            install_path=KF2_INSTALL_PATH
                        )
    os.system(test_execute)


elif args['publish']:
    config = build_config(CONFIG_FPATH)

    # Copy files into the publish folders
    for src, dest in config['workshop_copy']:
        src_fpath = src.format(
                            bin_path=KF2_BIN_PATH,
                            install_path=KF2_INSTALL_PATH,
                            brew_path=KF2_BREWED_PATH
                        )
        target_path = os.path.join(config['target'],dest)
        if not os.path.exists(target_path):
            os.makedirs(target_path)
        shutil.copy(src_fpath,target_path)

    # Then execute the workshop tool
    os.system(config["workshop_upload"].format(
        workshop_fpath=KF2_WORKSHOP_FPATH,
        target=config["workshop"]))

