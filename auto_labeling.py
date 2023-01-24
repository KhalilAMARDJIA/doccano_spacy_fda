import pandas as pd
import spacy
import json

nlp = spacy.load('Model/model-best')
data = pd.read_csv('input/event_data.csv', sep='|')
abstracts = data.text.dropna()

docs = nlp.pipe(abstracts)

data = []
for doc in docs:
    text = doc.text
    entities = []
    for ent in doc.ents:
        entities.append([ent.start_char, ent.end_char, ent.label_])
    data.append([text, {"entities": entities}])

with open("input/autolabeled_data.jsonl", "w") as f:
    for i, item in enumerate(data):
        json_obj = {"text": item[0], "label": item[1]["entities"]}
        json.dump(json_obj, f)
        f.write("\n")