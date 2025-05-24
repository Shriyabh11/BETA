# 🧠 BETA – Your Smart Type 1 Diabetes Companion

**BETA** is a personalized AI-powered assistant for people with Type 1 Diabetes (T1D), offering mental health support, health and nutrition logging, conversational interaction, and the latest diabetic news—all in one place.

> ⚠️ **Note:** This is a **very early beta version**.

---

## ✨ Features

### 🗨️ Ask Anything
- Talk to your assistant like a friend.
- Powered by **Google Gemini** for natural, smart responses.
- Built-in **query classifier** decides if your question is about:
  - 🥗 **Nutrition**
  - 🧠 **Mental Health**
  - 🩺 **General Health**
  - ❓ Other

#### 🥗 Nutrition Q&A
- Gemini detects food-related questions.
- App fetches real-time **nutrition facts** from a trusted API.
- Runs **multi-step RAG** (Retrieval-Augmented Generation) to analyze how nutrients impact blood sugar and diabetes.
- Gemini explains it all clearly — combining data + reasoning.

#### 🧠 General Health Q&A
- Answers T1D-specific and general health queries.
- Uses embedded trusted documents with Gemini for personalized, accurate responses.
- Warns users if no trusted info is available (transparency-first).

---

### 💬 Wanna Talk? (Mental Health Support)
- Talk about how you're feeling.
- First, a **Depression Classifier** checks for signs of depression.
- Then Gemini offers:
  - Supportive conversation
  - Mindfulness prompts
  - Journaling & reflection ideas
- Not a therapist — just a warm and always-available companion 

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


