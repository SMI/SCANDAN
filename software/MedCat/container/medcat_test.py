import json, pathlib, sys
from medcat.cat import CAT


import torch
print('CUDA available? %s' % torch.cuda.is_available())
print('CUDA devices: %d' % torch.cuda.device_count())
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print('Using device type:', device)
if device.type == 'cuda':
    print('Device: %s' % torch.cuda.get_device_name(0))
    print('Memory Allocated:', round(torch.cuda.memory_allocated(0)/1024**3,1), 'GB')
    print('Memory Cached:   ', round(torch.cuda.memory_reserved(0)/1024**3,1), 'GB')

print('Using model: %s' % sys.argv[1])
cat = CAT.load_model_pack(sys.argv[1])
print('Reading text file: %s' % sys.argv[2])
text = pathlib.Path(sys.argv[2]).read_text()
entities = cat.get_entities(text)
print('Saving output file: %s' % sys.argv[3])
pathlib.Path(sys.argv[3]).write_text(json.dumps(entities))
