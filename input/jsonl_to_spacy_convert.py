import jsonlines
import spacy
from tqdm import tqdm
from spacy.tokens import DocBin


def rand_split_list(list, split_ratio):

    import random
    random.shuffle(list)
    split = round(len(list)*split_ratio)
    train_data = list[:split]
    test_data = list[split:]
    return train_data, test_data

def convert(input_list,output_path):
    nlp = spacy.blank("en") # load a new spacy model
    db = DocBin() # create a DocBin object
    TRAIN_DATA = input_list
    print(len(TRAIN_DATA)) # check if the data is passed correctly
    for text, annot in tqdm(TRAIN_DATA): # data in previous format
        doc = nlp.make_doc(text) # create doc object from text
        ents = []
        for start, end, label in annot:# add character indexes
            span = doc.char_span(start, end, label=label)
            if span is None:
                print("Skipping entity")
            else:
                ents.append(span)
        doc.ents = ents # label the text with the ents
        db.add(doc)
    db.to_disk(output_path)


with jsonlines.open("input/fda_curated.jsonl", mode='r') as reader:
    data = [example for example in reader]


nlp = spacy.blank("en")

training_data =[]

for eg in data:
    text = eg['text']
    entities = eg['label']
    for start, end, label in entities:
        if start > len(text) or end > len(text):
            print("Entities index out of range for text: ", text)
    training_data.append((text, entities))


train, valid = rand_split_list(list = training_data, split_ratio = 0.8)


convert(input_list= train, output_path="./input/training_data_outcomes.spacy")
convert(input_list= valid, output_path="./input/validation_data_outcomes.spacy")
