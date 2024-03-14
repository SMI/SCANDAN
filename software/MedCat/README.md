# MedCat

We use conda or pip to install. Instruction at: https://github.com/CogStack/MedCAT.
We also need to download the models pre-trained by MedCAT,
see https://github.com/CogStack/MedCAT#snomed-ct-and-umls.

See our [tutorial](tutorial.md)

# Dependencies

N/A (or PyTorch 1.9.1, CUDA 10.2 or 11.1 as the lastest PyTorch huggingface can be used to enhance MedCAT.
See https://towardsdatascience.com/integrating-transformers-with-medcat-for-biomedical-ner-l-8869c76762a)

# Models

https://github.com/CogStack/MedCAT#available-models
https://medcat.readthedocs.io/en/latest/main.html#models

* umls_sm
  - UMLS Small (A modelpack containing a subset of UMLS (disorders, symptoms, medications...). Trained on MIMIC-III)
  - 498MB  umls_sm_pt2ch_533bab5115c6c2d6.zip

* umls_self_train_model
  - SNOMED International (Full SNOMED modelpack trained on MIMIC-III)
  - 1.6GB  umls_self_train_model_pt2ch_3760d588371755d0.zip

* UMLS Dutch v1.10
  - a modelpack provided by UMC Utrecht containing UMLS entities with Dutch names trained on Dutch medical wikipedia articles and a negation detection model repository/paper trained on EMC Dutch Clinical Corpus.

* mc_modelpack_snomed
  - UMLS Full. >4MM concepts trained self-supervsied on MIMIC-III. v2022AA of UMLS.
  - 670MB  mc_modelpack_snomed_int_16_mar_2022_25be3857ba34bdd5.zip

