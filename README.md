# 🧠 ML Conference Countdown (Übersicht Widget)

A minimal Übersicht widget that shows live countdowns to submission deadlines for top machine learning and computer science conferences:

- AAAI (Artificial Intelligence)
- CVPR (Computer Vision) 
- ICLR (International Conference on Learning Representations)
- VLDB (Very Large Data Bases)

It uses official timezones and updates once a week via data from [CCF Deadlines](https://github.com/ccfddl/ccf-deadlines).

---

## ✨ Features

- ⏱ Real-time countdown, updated every second
- 🌐 Timezone-aware (e.g., UTC−8 for NeurIPS)
- 📅 Weekly auto-refresh via cached JSON
- 🪶 Clean display with year tag like `ICLR'26`
- 🔁 Easily swappable for other conferences
- 📋 Prioritizes **abstract deadlines** over paper deadlines

---

## 🔄 Customize Your Conferences

You can replace the default conferences with others from the CCF repository such as:

- **ACL** (Natural Language Processing)
- **ICML** (Machine Learning)
- **NeurIPS** (Neural Information Processing)
- **SIGMOD** (Database Systems)
- **SIGGRAPH** (Computer Graphics)
- Any other from the [CCF Deadlines repository](https://github.com/ccfddl/ccf-deadlines/tree/main/conference)

### 🛠 How to change:

1. Open `ml_fetch.sh`
2. Find the `CONFERENCES` array:
   ```bash
   CONFERENCES=(
     "AI|aaai.yml|AAAI"
     "CG|cvpr.yml|CVPR" 
     "AI|iclr.yml|ICLR"
     "DB|vldb.yml|VLDB"
   )
   ```
3. Replace entries with your preferred conferences using the format: `"CATEGORY|filename.yml|DISPLAY_NAME"`
   - **CATEGORY**: AI, CG, DB, etc. (check the CCF repo structure)
   - **filename.yml**: The actual YAML file name in the CCF repository
   - **DISPLAY_NAME**: How you want it shown in the widget
4. Save the file, delete the cached data file `ml_data.json` and refresh the widget.

---

## 📦 Install

### 1. Install [Übersicht](http://tracesof.net/uebersicht/)

### 2. Clone this widget into your Übersicht widgets folder:

```bash
cd ~/Library/Application\ Support/Übersicht/widgets
git clone https://github.com/Happy2Git/ML_Big3_Countdown.git
```

### 3. Install dependencies:

```bash
brew install yq jq
```

### 4. Refresh Übersicht:

Click on **Übersicht → Refresh All Widgets** in the menu bar.

---

## 🧠 Data Source

* [CCF Deadlines](https://github.com/ccfddl/ccf-deadlines) - China Computer Federation recommended conferences

---

## 🗂 Files

```
ML_Big3_Countdown/
├── ml3.coffee         # The widget logic
├── ml_data.json       # Cached data
├── ml_fetch.sh        # Weekly YAML-to-JSON conversion from CCF repo
```

---

## 📸 Screenshot

![Screen capture](./screenshot.png)

---

## 🔧 Advanced Configuration

### Conference Categories Available:
- **AI**: Artificial Intelligence conferences
- **CG**: Computer Graphics conferences  
- **DB**: Database conferences
- **NW**: Network System conferences
- **SC**: Security conferences
- **SE**: Software Engineering conferences

### Deadline Priority:
The widget prioritizes **abstract deadlines** over paper deadlines when available, helping you catch the earliest submission opportunity.

---

## 📄 License

MIT License

---

## 🙌 Credits

Thanks to [CCF Deadlines](https://github.com/ccfddl/ccf-deadlines) for providing comprehensive conference deadline data.

Widget by Clawen(Cheng-Long Wang)