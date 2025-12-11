const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const moment = require("moment-timezone");
const { GoogleGenerativeAI } = require("@google/generative-ai");
const cors = require('cors')({ origin: true });

admin.initializeApp();

// Initialize Gemini
// Note: You must set the API key in Firebase environment config:
// firebase functions:config:set gemini.key="YOUR_API_KEY"
// Or use process.env.GEMINI_API_KEY if configured differently.
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || "AIzaSyDzJtWliS0YvEJheofNBd29Q1vSM6swn8g");

// Using gemini-1.5-flash
const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" });

exports.getPrayerTimes = functions.https.onRequest((req, res) => {
    cors(req, res, async () => {
        // ... (Prayer Times logic remains unchanged - keeping it brief for this replace, but effectively I'm not touching inside here if I can avoid it, but replace_file_content replaces the whole block if I select it. 
        // Wait, I should not replace getPrayerTimes if I don't have to.
        // I will target the model definition and the two AI functions specifically.)

        // Actually, the user asked to "replace ALL old model names" and "replace the entire Gemini call".
        // To be safe and clean, I will rewrite the file content for the AI parts.

        // RE-INITIALIZING getPrayerTimes logic to ensure I don't delete it
        const lat = req.query.lat;
        const lon = req.query.lon;
        const dateStr = req.query.date; // YYYY-MM-DD
        const method = req.query.method || 2; // Default to Muslim World League

        if (!lat || !lon) {
            res.status(400).send({ error: "Missing latitude or longitude parameters." });
            return;
        }

        // Use provided date or default to today
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

            // Parse times to simpler format
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
                // Sunrise usually skipped for "next prayer" logic unless specified
                { name: "Dhuhr", time: dhuhr },
                { name: "Asr", time: asr },
                { name: "Maghrib", time: maghrib },
                { name: "Isha", time: isha }
            ];

            let nextPrayerName = "Fajr";
            let nextPrayerTime = fajr;

            // Convert prayer times to moment objects for today
            for (const p of prayerMap) {
                const pTime = moment.tz(`${moment().format('YYYY-MM-DD')} ${p.time}`, "YYYY-MM-DD HH:mm", timezone);
                if (pTime.isAfter(now)) {
                    nextPrayerName = p.name;
                    nextPrayerTime = p.time;
                    break;
                }
            }

            res.json({
                fajr,
                sunrise,
                dhuhr,
                asr,
                maghrib,
                isha,
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
            // User-provided Template logic
            const prompt = `
You are Horeen, the MuslimLife AI assistant.
Provide gentle, uplifting reminders. No fatwas. Maximum 2 sentences.
Event Data:
${JSON.stringify(req.body, null, 2)}
`;

            // Simplified Syntax
            const result = await model.generateContent([{ text: prompt }]);
            const response = await result.response;
            const text = response.text();

            // Clean up Markdown if present
            let cleanText = text.replace(/```json/g, "").replace(/```/g, "").trim();

            // Attempt JSON parse or return text
            let jsonResponse;
            try {
                jsonResponse = JSON.parse(cleanText);
            } catch (e) {
                // If not JSON, wrapped in standard format
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
            const prompt = `
You are Noor — نور , the MuslimLife AI assistant.
Provide gentle, faith-inspired guidance. 
Do not give fatwas or strict rulings. 
Keep answers short (max 2–3 sentences).
User Message:
${message}
`;

            // Simplified Syntax
            const result = await model.generateContent([{ text: prompt }]);
            const response = await result.response;
            const text = response.text();

            res.json({ reply: text });

        } catch (err) {
            console.error("Chat Error:", err);
            res.status(500).json({ error: err.message });
        }
    });
});
