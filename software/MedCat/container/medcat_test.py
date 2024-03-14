import json, pathlib, sys
from medcat.cat import CAT
cat = CAT.load_model_pack(sys.argv[1])
text = pathlib.Path(sys.argv[2]).read_text()
entities = cat.get_entities(text)
pathlib.Path(sys.argv[3]).write_text(json.dumps(entities))
