# 🧠 BETA – Your Smart Type 1 Diabetes Companion

**BETA** is a personalized AI-powered assistant for people with Type 1 Diabetes (T1D), offering mental health support, health and nutrition logging, conversational interaction, and the latest diabetic news—all in one place.

> ⚠️ **Note:** This is a **very early beta version**.

---

## ✨ Features

### 🗨️ Ask Anything
- Ask assitant any question, which is first classified into one of the 3 categories: nutrional, health related, and other.
- Powered by **Google Gemini** for natural, smart responses.

#### 🥗 Nutrition Q&A
- Gemini detects food-related questions.
- App fetches real-time **nutrition facts** from a trusted API.
- Gemini explains it all clearly — combining data + reasoning.

#### 🧠 General Health Q&A
- Answers T1D-specific and general health queries.
- Uses embedded trusted documents with Gemini for personalized, accurate responses.
-  Runs **multi-step RAG** (Retrieval-Augmented Generation)
- Warns users if no trusted info is available (transparency-first).

---

### 💬 Wanna Talk? (Mental Health Support)
- Talk about how you're feeling.
- First, a **Depression Classifier** checks for signs of depression.
- Then Gemini offers supportive conversation
---

### 📋 Health Logger
- Log your daily experiences in plain English (no forms!).
- Smart parser uses **Token Classification + NER** to pull structured data from logs like:
  - Blood sugar 
  - Sleep
  - exercise
  - Food 


---

### 📰 Type 1 Diabetes News
- Browse the latest news on T1D treatments, research, and tech.
- Keeps you informed and empowered.

---

## 🛠️ Tech Stack

### 🌐 Frontend
- **Flutter** – Smooth, responsive cross-platform UI for mobile

### 🧠 Backend
- **Python** – Handles query routing, models, and data processing.
- **Google Gemini API** – For chat, question answering, and mental health support.
- **Firebase** – For secure authentication and user data storage.
- **Nutrition API** – Trusted food facts source.
- **LangChain / RAG pipeline** – Embedded docs → better answers.
- **NER + Token Classifier** – Extracts health insights from logs.
- **Mental Health Model** – Binary classifier to detect depression signs.

---


