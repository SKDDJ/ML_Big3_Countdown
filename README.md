# 🧠 ML Conference Countdown (Übersicht Widget)

A minimal Übersicht widget that shows live countdowns to submission deadlines for top machine learning conferences:

- ICLR
- ICML
- NeurIPS

It uses official timezones and updates once a week via data from [Hugging Face AI Deadlines](https://github.com/huggingface/ai-deadlines).

---

## ✨ Features

- ⏱ Real-time countdown, updated every second
- 🌐 Timezone-aware (e.g., UTC−8 for NeurIPS)
- 📅 Weekly auto-refresh via cached JSON
- 🪶 Clean display with year tag like `ICML’25`
- 🔁 Easily swappable for other conferences

---

## 🔄 Customize Your Conferences

You can replace the default conferences (`ICLR`, `ICML`, `NeurIPS`) with others like:

- **ACL**
- **CVPR**
- **EMNLP**
- **COLT**
- Any other from the full list on [Hugging Face AI Deadlines](https://github.com/huggingface/ai-deadlines/blob/main/src/data/conferences.yml)

### 🛠 How to change:

1. Open `ml_fetch.sh`
2. Find this line:
   ```bash
   select(.title == "ICLR" or .title == "ICML" or .title == "NeurIPS")
	```
3. Replace or add the conference names inside the select() filter with your preferred ones (e.g., "ACL", "CVPR").
4. Save the file, delete the cached data file `ml_data.json` and refresh the widget.
---

## 📦 Install

### 1. Install [Übersicht](http://tracesof.net/uebersicht/)

### 2. Clone this widget into your Übersicht widgets folder:

```bash
cd ~/Library/Application\ Support/Übersicht/widgets
git clone https://github.com/Happy2Git/ML_Big3_Countdown.git
````

### 3. Install dependencies:

```bash
brew install yq jq
```

### 4. Refresh Übersicht:

Click on **Übersicht → Refresh All Widgets** in the menu bar.

---

## 🧠 Data Source

* [Hugging Face AI Deadlines](https://github.com/huggingface/ai-deadlines)

---

## 🗂 Files

```
ml-conference-deadlines/
├── ml3.coffee         # The widget logic
├── ml_data.json       # Cached data
├── ml_fetch.sh        # Weekly YAML-to-JSON conversion
```

---

## 📸 Screenshot

![Screen capture](./screenshot.png)

---

## 📄 License

MIT License

---

## 🙌 Credits

Thanks to [huggingface/ai-deadlines](https://github.com/huggingface/ai-deadlines)

Widget by Clawen(Cheng-Long Wang)