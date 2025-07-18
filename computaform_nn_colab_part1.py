
# 📘 COMPUTAFORM INTELLIGENCE ENGINE - PART 1
# Unsupervised Neural Network Preprocessing & Setup (Google Colab Notebook)

# ✅ STEP 1: Install Dependencies
!pip install -q fitz PyMuPDF pandas scikit-learn transformers

# ✅ STEP 2: Import Libraries
import fitz  # For PDF parsing
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from transformers import AutoTokenizer, AutoModel
import torch

# ✅ STEP 3: Load the Computaform PDF
from google.colab import files
uploaded = files.upload()  # Upload your Computaform PDF here manually

# Load PDF and extract text
doc = fitz.open(next(iter(uploaded)))
raw_text = ""
for page in doc:
    raw_text += page.get_text("text")

# ✅ STEP 4: Extract Comments and Associated Data
import re

# Extract horse blocks with names, race numbers, comments, etc.
pattern = re.compile(r'(\d+)\s+-\s+(\d+)\s+([A-Z\- ]+?)\s+\d+[^\n]*?\n(.+?)(?=\d+\s+-|\Z)', re.DOTALL)
matches = pattern.findall(raw_text)

# Create dataframe
horses = []
for match in matches:
    race_num, draw, name, comment = match
    horses.append({
        "race": int(race_num),
        "draw": int(draw),
        "name": name.strip(),
        "raw_comment": comment.strip().replace("\n", " ")
    })
df = pd.DataFrame(horses)

# ✅ STEP 5: Text Embedding with Transformer Model (No predefined features)
tokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")
model = AutoModel.from_pretrained("bert-base-uncased")
model.eval()

# Generate embeddings
def get_embedding(text):
    with torch.no_grad():
        inputs = tokenizer(text, return_tensors="pt", truncation=True, max_length=128)
        outputs = model(**inputs)
        return outputs.last_hidden_state.mean(dim=1).squeeze().numpy()

df["embedding"] = df["raw_comment"].apply(get_embedding)

# ✅ STEP 6: Preview Sample
df[["race", "draw", "name", "raw_comment"]].head()
