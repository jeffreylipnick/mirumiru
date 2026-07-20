import sqlite3
import xml.etree.ElementTree as ET
from pathlib import Path

XML_FILE = Path("Tools/JMdict_e")
DB_FILE = Path("Tools/jmdict.sqlite")

if DB_FILE.exists():
    DB_FILE.unlink()

conn = sqlite3.connect(DB_FILE)
cur = conn.cursor()

cur.execute("""
CREATE TABLE entries (
    id INTEGER PRIMARY KEY,
    kanji TEXT,
    reading TEXT,
    meanings TEXT,
    parts_of_speech TEXT
)
""")

tree = ET.parse(XML_FILE)
root = tree.getroot()

count = 0

for entry in root.findall("entry"):

    meanings = []

    for sense in entry.findall("sense"):
        for gloss in sense.findall("gloss"):
            meanings.append(gloss.text)

    parts = []

    for sense in entry.findall("sense"):
        for pos in sense.findall("pos"):
            parts.append(pos.text)

    readings = entry.findall("r_ele")
    kanjis = entry.findall("k_ele")

    if not readings:
        continue

    reading = readings[0].findtext("reb")

    kanji = None
    if kanjis:
        kanji = kanjis[0].findtext("keb")

    cur.execute(
        """
        INSERT INTO entries
        (kanji, reading, meanings, parts_of_speech)
        VALUES (?, ?, ?, ?)
        """,
        (
            kanji,
            reading,
            "\n".join(meanings),
            "\n".join(parts)
        )
    )

    count += 1

conn.commit()
conn.close()

print(f"Imported {count} entries")
