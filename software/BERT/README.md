# BERT

BERT and other large pre-trained language models in the general and clinical domains.

## Dependencies

We use wget (with some ftp transfer if needed) command to download all
mainstream BERT models from the Huggingface model hub
(see https://huggingface.co/models) and Google Tensorflow models
(https://github.com/google-research/bert).
The base and large models include but not limited to BERT
(Tensorflow and huggingface models), ClinicalBERT, BioBERT,
BlueBERT (Tensorflow and huggingface models), SapBERT,
PubMedBERT (Tensorflow and huggingface models),  BioRedditBERT,
and biomed_roberta_base.

Also we install bert-as-service (https://github.com/hanxiao/bert-as-service)
for feature extraction with Google Tensorflow models.

For huggingface BERT models: PyTorch - latest version (e.g. 1.9.1), CUDA 10.2 or 11.1. For BERT-as-service and Google Tensorflow Models: tensorflow>=1.10 (e.g. 1.15.5), CUDA 10.0.
