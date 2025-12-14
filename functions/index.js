const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const moment = require("moment-timezone");
const { OpenAI } = require("openai"); // SWITCHED TO OPENAI
const cors = require('cors')({ origin: true });

admin.initializeApp();

// Initialize OpenAI
// Ensure you set the key: firebase functions:config:set openai.key="sk-..."
const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY || functions.config().openai.key,
});

exports.getPrayerTimes = functions.https.onRequest((req, res) => {
    cors(req, res, async () => {
        const lat = req.query.lat;
        const lon = req.query.lon;
        const dateStr = req.query.date; // YYYY-MM-DD
        const method = req.query.method || 2;

        if (!lat || !lon) {
            res.status(400).send({ error: "Missing latitude or longitude parameters." });
            return;
        }

        const targetDate = dateStr ? moment(dateStr, "YYYY-MM-DD").format("DD-MM-YYYY") : moment().format("DD-MM-YYYY");

        try {
            const apiUrl = `https://api.aladhan.com/v1/timings/${targetDate}?latitude=${lat}&longitude=${lon}&method=${method}`;
            const response = await axios.get(apiUrl);
            const data = response.data;

            if (data.code !== 200) {
                throw new Error("AlAdhan API returned non-200 code");
            }

            const timings = data.data.timings;
            const meta = data.data.meta;
            const timezone = meta.timezone;

            const cleanTime = (t) => t.split(' ')[0];

            const fajr = cleanTime(timings.Fajr);
            const sunrise = cleanTime(timings.Sunrise);
            const dhuhr = cleanTime(timings.Dhuhr);
            const asr = cleanTime(timings.Asr);
            const maghrib = cleanTime(timings.Maghrib);
            const isha = cleanTime(timings.Isha);

            // Calculate Next Prayer
            const now = moment().tz(timezone);
            const prayerMap = [
                { name: "Fajr", time: fajr },
                { name: "Dhuhr", time: dhuhr },
                { name: "Asr", time: asr },
                { name: "Maghrib", time: maghrib },
                { name: "Isha", time: isha }
            ];

            let nextPrayerName = "Fajr";
            let nextPrayerTime = fajr;

            for (const p of prayerMap) {
                const pTime = moment.tz(`${moment().format('YYYY-MM-DD')} ${p.time}`, "YYYY-MM-DD HH:mm", timezone);
                if (pTime.isAfter(now)) {
                    nextPrayerName = p.name;
                    nextPrayerTime = p.time;
                    break;
                }
            }

            res.json({
                fajr, sunrise, dhuhr, asr, maghrib, isha,
                nextPrayer: nextPrayerName,
                nextPrayerTime: nextPrayerTime
            });

        } catch (error) {
            console.error("Error fetching prayer times:", error);
            res.status(500).send({ error: "Failed to fetch prayer times.", details: error.message });
        }
    });
});

exports.generateInsight = functions.https.onRequest((req, res) => {
    cors(req, res, async () => {
        try {
            const prompt = `
You are Horeen, the MuslimLife AI assistant.
Provide gentle, uplifting reminders. No fatwas. Maximum 2 sentences.
Event Data:
${JSON.stringify(req.body, null, 2)}
`;

            const completion = await openai.chat.completions.create({
                model: "gpt-4o-mini", // Faster & Cheaper than Gemini Flash
                messages: [{ role: "user", content: prompt }],
            });

            const text = completion.choices[0].message.content;

            // Clean up Markdown if present
            let cleanText = text.replace(/```json/g, "").replace(/```/g, "").trim();

            let jsonResponse;
            try {
                jsonResponse = JSON.parse(cleanText);
            } catch (e) {
                jsonResponse = {
                    title: "AI Insight",
                    message: cleanText,
                    type: "insight"
                };
            }

            res.json(jsonResponse);

        } catch (err) {
            console.error("Insight Error:", err);
            res.status(500).json({ error: err.message });
        }
    });
});

exports.aiChat = functions.https.onRequest((req, res) => {
    cors(req, res, async () => {
        const { message } = req.body;

        if (!message) {
            res.status(400).json({ error: "Missing message parameter." });
            return;
        }

        try {
            const completion = await openai.chat.completions.create({
                model: "gpt-4o-mini",
                messages: [
                    {
                        role: "system",
                        content: `You are Noor — نور , the MuslimLife AI assistant.

                        IMPORTANT RULES:
                        - You must be accurate, culturally aware, and cautious.
                        - If a word in Dari, Persian, Pashto, Arabic, English, or any other language is slang, sexual, or ambiguous, DO NOT reinterpret it spiritually.
                        - Never invent religious meanings for slang or sensitive terms.
                        - If a term has multiple meanings, ask for clarification before answering.
                        - When discussing sensitive topics (e.g. masturbation), respond factually and respectfully according to mainstream Islamic understanding.
                        - Do not give fatwas. Do not moralize poetically.
                        - Keep answers short (2–3 sentences).`
                    },
                    { role: "user", content: message }
                ],
            });

            const text = completion.choices[0].message.content;
            res.json({ reply: text });

        } catch (err) {
            console.error("Chat Error:", err);
            res.status(500).json({ error: err.message });
        }
    });
});