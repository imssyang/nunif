import torch, subprocess


def basic_envs():
    print("Torch:", torch.__version__)
    try:
        print("CUDA Available:", torch.cuda.is_available())
        print("Device Count:", torch.cuda.device_count())
        print("NCCL Version:", torch.cuda.nccl.version())
    except Exception as e:
        print("Error:", e)


def gpu_communication():
    a = torch.randn(2, device='cuda:0')
    b = a.to('cuda:1')
    print("copy done")


if __name__ == "__main__":
    basic_envs()
    gpu_communication()
