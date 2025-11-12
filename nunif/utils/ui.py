import os
from os import path
import sys
import torch
import mimetypes


class HiddenPrints:
    def __init__(self):
        debug = os.getenv("DEBUG")
        if debug is not None and debug.isdigit():
            self.debug = int(debug)
        else:
            self.debug = 0

    def __enter__(self):
        if self.debug:
            return
        self._original_stdout = sys.stdout
        self._original_stderr = sys.stderr
        sys.stdout = open(os.devnull, 'w')
        sys.stderr = open(os.devnull, 'w')

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.debug:
            return
        sys.stdout.close()
        sys.stderr.close()
        sys.stdout = self._original_stdout
        sys.stderr = self._original_stderr


class TorchHubDir:
    def __init__(self, hub_dir):
        self.hub_dir = hub_dir
        self.original_hub_dir = None

    def __enter__(self):
        self.original_hub_dir = torch.hub.get_dir()
        torch.hub.set_dir(self.hub_dir)

    def __exit__(self, exc_type, exc_val, exc_tb):
        torch.hub.set_dir(self.original_hub_dir)


def is_rtmp(filename):
    if filename.startswith("rtmp://") or filename.startswith("rtmps://"):
        return True
    else:
        return False


def is_netstream(filename):
    if filename.startswith("rtmp://") or filename.startswith("rtmps://"):
        return True
    elif filename.startswith("rtsp://"):
        return True
    elif filename.startswith("http://") or filename.startswith("https://"):
        return True
    else:
        return False


def is_image(filename):
    if is_netstream(filename):
        return False
    else:
        mime = mimetypes.guess_type(filename)[0]
        return mime and mime.startswith("image")


def is_video(filename):
    if is_netstream(filename):
        return True
    else:
        mime = mimetypes.guess_type(filename)[0]
        return mime and mime.startswith("video")


def is_text(filename):
    if is_netstream(filename):
        return False
    else:
        mime = mimetypes.guess_type(filename)[0]
        return mime and mime.startswith("text")


def is_output_dir(filename):
    if is_netstream(filename):
        return False
    else:
        return path.isdir(filename) or "." not in path.basename(filename)


def make_parent_dir(filename):
    if not is_netstream(filename):
        parent_dir = path.dirname(filename)
        if parent_dir and not path.exists(parent_dir):
            os.makedirs(parent_dir, exist_ok=True)


def _list_subdir(dirname):
    subdirs = [f.path for f in os.scandir(dirname) if f.is_dir()]
    for dirname in list(subdirs):
        subdirs.extend(_list_subdir(dirname))
    return subdirs


def list_subdir(root_dir, include_root=False, excludes=None):
    if is_netstream(filename):
        return []
    else:
        subdirs = set(path.normpath(dirname) for dirname in _list_subdir(root_dir))
        if include_root:
            subdirs.add(path.normpath(root_dir))
        if excludes is not None:
            if not isinstance(excludes, (list, tuple)):
                excludes = [excludes]
            remove_dirs = set()
            for exclude_path in excludes:
                exclude_path = path.normpath(exclude_path)
                for dirname in subdirs:
                    if path.commonprefix([exclude_path, dirname]) == exclude_path:
                        remove_dirs.add(dirname)
            subdirs -= remove_dirs
        return sorted(list(subdirs))
