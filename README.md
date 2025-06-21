

# 📷 Zhuyin App (圖片轉注音 App)

A Flutter desktop app that lets you **upload an image of Traditional Chinese text** and **convert it into Zhuyin (注音)** — making reading and pronunciation easier for learners and heritage speakers.

---

## 🧠 Project Purpose

As a Taiwanese who grew up abroad, I often forgot how to pronounce certain Chinese characters while reading. Since most input methods are phonetic-based (Zhuyin), looking up unknown characters becomes difficult. This app solves that by allowing you to:

- 🖼 Upload an image containing Traditional Chinese text  
- 🔍 Recognize the text using **Google Cloud Vision API**  
- 🧾 Convert recognized characters into **Zhuyin (注音)**  
- ⌨️ Type/paste text directly for conversion 

> Most Chinese dictionaries do not support **image-based input**, which this app enables.

---

## ✅ Features

- [x] Upload and display images from your device
- [x] Recognize Traditional Chinese text via OCR (Google Cloud Vision API)
- [x] Convert recognized text to Zhuyin using MOE resources
- [x] Support typing or pasting text for Zhuyin conversion (in progress)
- [ ] Cutified UI redesign (planned)
- [ ] Crop or select text regions in image (planned)


---

## 🗓️ Development Log

### 2025.06.13
- ✅ Enabled image upload from device
- ✅ Integrated Google Cloud Vision API
- ⚠️ Encountered issues with character-to-Zhuyin mapping — needed better dataset

### 2025.06.21
- ✅ Image-to-Zhuyin transformation complete
- ✅ Verified accuracy using MOE public data
- 🧹 Next Up:
  - Replace temporary dictionary with official licensed dataset
  - Add text input mode
  - Clean up API keys and ensure proper attribution

---

## 🗃️ Resources & Licensing

### 📚 Zhuyin Dictionary Source
- [教育部重編國語辭典（修訂本）文字資料庫](https://language.moe.gov.tw/001/Upload/Files/site_content/M0001/respub/dict_reviseddict_download.html)
- GitHub mirror: [g0v/moedict-data](https://github.com/g0v/moedict-data)

### ⚠️ License Notice
- Dictionary data is from the **MOE Revised Mandarin Chinese Dictionary**, copyright belongs to the **Ministry of Education (Taiwan)**.
- Licensed under **Creative Commons Attribution-NoDerivatives 3.0 Taiwan (CC BY-ND 3.0 TW)** — format conversion and application are allowed.
- Data conversion script by @kcwu is released under **CC0**.

> Full license: [MOE 公眾授權說明](https://language.moe.gov.tw/001/Upload/Files/site_content/M0001/respub/index.html)

---

## 🧠 What I Learned

- Building desktop UI with Flutter  
- Integrating Google Cloud Vision OCR  
- Using Cursor (Vibe Coding) for development  
- Understanding licensing of public linguistic datasets

---

## 💡 Future Improvements

- Integrate Chinese Specified LLMs for more accurate or contextual pronunciation
- Add cropping/selecting part of the uploaded image
- Build mobile version in the future
- Polish the UI with a cuter, more user-friendly design
- Improve Chinese text parsing and tone disambiguation

---

## 🔒 Security & Clean-Up Checklist

- [ ] Remove API keys from version control  
- [ ] Avoid redistributing dictionary file directly — load from safe source  
- [ ] Add proper license attribution in About section
