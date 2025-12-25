import React, { useState, useEffect, useRef } from 'react';
import { 
  Play, BookOpen, ChevronRight, Sparkles, Compass, 
  ArrowUp, Mic, SkipBack, SkipForward, Share2, 
  History, Star, ChevronLeft, Settings, Pause, 
  ChevronDown, Home, Clock, Search, MapPin, Activity,
  Users, Book, MessageCircle, Heart, Info, CheckCircle2,
  Bell, Globe, Map, Navigation, ShieldCheck, Wifi, RefreshCcw,
  Loader2, ScrollText, Sunrise, Sunset, Check
} from 'lucide-react';

// --- Gemini API Configuration ---
const apiKey = ""; 
const GEMINI_MODEL = "gemini-2.5-flash-preview-09-2025";

const App = () => {
  // --- Navigation & View State ---
  const [view, setView] = useState('home'); 
  const [selectedSurah, setSelectedSurah] = useState(null);

  // --- Gemini Specific State ---
  const [aiLoading, setAiLoading] = useState(false);
  const [tutorInput, setTutorInput] = useState("");
  const [chatHistory, setChatHistory] = useState([
    { role: 'model', text: "Assalamu Alaikum. I am MuslimMind. How can I assist your spiritual journey today?" }
  ]);
  const [dailyReflection, setDailyReflection] = useState("And He is with you wherever you are.");
  const [surahInsight, setSurahInsight] = useState("");

  // --- Phase 2 Logic & Tracking ---
  const [timeLeft, setTimeLeft] = useState({ hours: 1, minutes: 21, seconds: 42 });
  const [qiblaAccuracy, setQiblaAccuracy] = useState('high');
  const [prayedLog, setPrayedLog] = useState({ Fajr: true, Sunrise: false, Dhuhr: false, Asr: false, Maghrib: false, Isha: false });

  useEffect(() => {
    const timer = setInterval(() => {
      setTimeLeft(prev => {
        if (prev.seconds > 0) return { ...prev, seconds: prev.seconds - 1 };
        if (prev.minutes > 0) return { ...prev, minutes: prev.minutes - 1, seconds: 59 };
        if (prev.hours > 0) return { hours: prev.hours - 1, minutes: 59, seconds: 59 };
        return prev;
      });
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  const formatTime = (val) => val.toString().padStart(2, '0');

  const togglePrayed = (prayerName) => {
    setPrayedLog(prev => ({ ...prev, [prayerName]: !prev[prayerName] }));
  };

  // --- Gemini API Integration ---
  const callGemini = async (prompt, systemPrompt = "") => {
    const url = `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent?key=${apiKey}`;
    const payload = {
      contents: [{ parts: [{ text: prompt }] }],
      systemInstruction: { parts: [{ text: systemPrompt }] }
    };
    try {
      const response = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });
      const data = await response.json();
      return data.candidates?.[0]?.content?.parts?.[0]?.text || "Link weak. Try again.";
    } catch (e) { return "Sanctuary link weak."; }
  };

  const fetchSurahIntro = async (surahName) => {
    setAiLoading(true);
    setSurahInsight("");
    const res = await callGemini(`2-sentence spiritual summary of Surah ${surahName}.`, "You are a scholar.");
    setSurahInsight(res);
    setAiLoading(false);
  };

  // --- Design Tokens (STRICT PHASE 2 LOCK) ---
  const colors = {
    bg: '#202124',        // Raisin Black (Root)
    surface: '#35363A',   // Lighter Elevation (Sophisticated Depth)
    surfaceDarker: '#292A2D',
    onSurface: '#F1F3F4', // Anti-Flash White
    textDim: '#9AA0A6',   // Muted UI Gray
    emerald: '#10B981',   
    gold: '#D4AF37',
    border: 'rgba(241, 243, 244, 0.08)' 
  };

  const activeSurahData = {
    id: 2, name: "Al-Baqarah", arabic: "البقرة", reciter: "Mishary Rashid Alafasy", progress: 42, place: "Medina", verses: 286,
    art: "https://images.unsplash.com/photo-1591633511295-81335039237e?auto=format&fit=crop&q=80&w=1200",
    readBg: "https://images.unsplash.com/photo-1507692049790-de58290a4334?auto=format&fit=crop&q=80&w=1600"
  };

  const surahs = [
    { id: 1, name: "Al-Fatiha", arabic: "الفاتحة", verses: 7, page: 1, place: "Mecca" },
    { id: 3, name: "Ali 'Imran", arabic: "آل عمران", verses: 200, page: 50, place: "Medina" },
    { id: 4, name: "An-Nisa", arabic: "النساء", verses: 176, page: 77, place: "Medina" },
  ];

  const prayers = [
    { name: "Fajr", arabic: "الفجر", time: "05:42", status: "done" },
    { name: "Sunrise", arabic: "الشروق", time: "07:21", status: "done" },
    { name: "Dhuhr", arabic: "الظهر", time: "12:04", status: "next" },
    { name: "Asr", arabic: "العصر", time: "15:35", status: "wait" },
    { name: "Maghrib", arabic: "المغرب", time: "16:48", status: "wait" },
    { name: "Isha", arabic: "العشاء", time: "18:27", status: "wait" },
  ];

  // --- VIEWS ---

  const renderHome = () => (
    <div className="animate-in fade-in duration-700 space-y-6 pb-96 px-2">
      {/* 1. HEADER: 12-DAY STREAK */}
      <header className="flex justify-between items-center px-4 py-3 bg-white/[0.04] rounded-[24px] border border-white/[0.05]">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-emerald-500/10 flex items-center justify-center border border-emerald-500/20">
            <Activity size={18} className="text-emerald-500" />
          </div>
          <div>
            <p className="text-[10px] font-black text-emerald-500 uppercase tracking-[0.2em]">12 Day Streak</p>
            <div className="flex gap-1.5 mt-1.5">
                {[1,1,1,1,1,0,1].map((s,i) => (
                    <div key={i} className={`w-3 h-1 rounded-full ${s ? 'bg-emerald-500 shadow-[0_0_8px_rgba(16,185,129,0.5)]' : 'bg-white/10'}`} />
                ))}
            </div>
          </div>
        </div>
        <div className="w-10 h-10 rounded-full border border-white/10 bg-white/5 flex items-center justify-center cursor-pointer hover:bg-white/10 transition-all">
            <Settings size={18} style={{ color: colors.onSurface }} className="opacity-40" />
        </div>
      </header>

      <div className="px-2">
        <h2 className="text-3xl font-light tracking-tight ml-2" style={{ color: colors.onSurface }}>Assalamu Alaikum</h2>
      </div>

      {/* 2. HERO: NEXT PRAYER CARD (LIGHTER SURFACE) */}
      <div className="px-2">
        <div 
          className="p-6 rounded-[32px] border border-white/[0.06] shadow-2xl relative overflow-hidden"
          style={{ backgroundColor: colors.surface }}
        >
          <div className="flex justify-between items-end mb-1">
            <div className="space-y-1">
              <p className="text-[10px] font-black tracking-[0.4em] uppercase opacity-30" style={{ color: colors.textDim }}>Next Prayer</p>
              <h2 className="text-4xl font-light tracking-tighter" style={{ color: colors.onSurface }}>Dhuhr</h2>
            </div>
            <div className="text-right pb-1">
              <span className="text-[9px] uppercase tracking-widest flex items-center gap-1.5 font-bold opacity-40" style={{ color: colors.textDim }}>
                <MapPin size={10} className="text-emerald-500"/> DC
              </span>
            </div>
          </div>
          <div className="flex items-baseline gap-4 py-4">
            <span className="text-7xl font-light tracking-tighter" style={{ color: colors.onSurface }}>{formatTime(timeLeft.hours)}:{formatTime(timeLeft.minutes)}</span>
            <span className="text-[11px] font-black tracking-[0.3em] text-emerald-500 uppercase pb-3">until Azan</span>
          </div>
          <div className="absolute bottom-0 left-0 right-0 h-1 bg-white/[0.02]">
            <div className="h-full bg-emerald-500/30" style={{ width: '65%' }} />
          </div>
        </div>
      </div>

      {/* 3. LIST HUB: VERTICAL CARDS (LIGHTER SURFACE) */}
      <div className="space-y-4 px-2">
        {[
            { id: 'library', title: 'The Holy Quran', sub: 'RESUME AL-BAQARAH', icon: <BookOpen size={20}/> },
            { id: 'hadith', title: 'Hadith Collection', sub: 'DAILY PROPHETIC WISDOM', icon: <Book size={20}/> },
            { id: 'community', title: 'Community Finder', sub: 'LOCAL EVENTS & MASJIDS', icon: <Users size={20}/> },
            { id: 'tutor', title: 'MuslimMind AI Tutor', sub: 'GEMINI POWERED GUIDANCE', icon: <Sparkles size={20}/> },
            { id: 'qibla', title: 'Qibla Finder', sub: 'PRECISE MECCA DIRECTION', icon: <Compass size={20}/> },
            { id: 'azan', title: 'Azan Schedule', sub: 'PRAYER TIME TIMELINE', icon: <Clock size={20}/> }
        ].map(item => (
            <div 
              key={item.id} 
              onClick={() => setView(item.id)} 
              className="group p-5 rounded-[28px] flex justify-between items-center cursor-pointer transition-all hover:translate-x-1 border border-white/[0.06] shadow-xl" 
              style={{ backgroundColor: colors.surface }}
            >
                <div className="flex items-center gap-5">
                   <div className="w-12 h-12 rounded-2xl bg-black/20 flex items-center justify-center text-stone-400 group-hover:text-emerald-500 border border-white/5 transition-all group-active:scale-95">
                     {item.icon}
                   </div>
                   <div>
                      <h4 className="text-lg font-medium tracking-tight group-hover:text-emerald-400 transition-colors" style={{ color: colors.onSurface }}>{item.title}</h4>
                      <p className="text-[9px] font-black uppercase tracking-[0.2em] opacity-30 mt-1" style={{ color: colors.textDim }}>{item.sub}</p>
                   </div>
                </div>
                <ChevronRight size={18} style={{ color: colors.onSurface }} className="opacity-10 group-hover:opacity-100 group-hover:translate-x-2 transition-all" />
            </div>
        ))}
      </div>

      {/* 4. FOOTER: DAILY INSIGHT */}
      <div className="pt-16 pb-12 border-t border-white/5 text-center px-8">
         <p className="font-serif italic text-xl leading-relaxed mb-6 opacity-60" style={{ color: colors.onSurface }}>
           "{dailyReflection}"
         </p>
         <div className="flex flex-col items-center gap-3">
            <div className="w-8 h-0.5 bg-emerald-500/20" />
            <span className="text-[10px] font-black text-emerald-500/60 uppercase tracking-[0.5em]">Sanctuary Insight</span>
         </div>
      </div>
    </div>
  );

  const renderLibrary = () => (
    <div className="animate-in fade-in duration-700 pb-80 px-2">
      <header className="mb-8 flex justify-between items-center px-4 pt-2">
        <button onClick={() => setView('home')} className="p-2 -ml-2 opacity-60 hover:opacity-100 transition-all"><ChevronLeft size={24} style={{ color: colors.onSurface }}/></button>
        <h1 className="text-xl font-light tracking-tight" style={{ color: colors.onSurface }}>Library</h1>
        <div className="w-10 h-10 bg-white/5 rounded-full flex items-center justify-center opacity-40"><Search size={18} style={{ color: colors.onSurface }}/></div>
      </header>

      {/* CINEMATIC HERO (LIGHTER SURFACE) */}
      <div 
        onClick={() => { setSelectedSurah(activeSurahData); fetchSurahIntro(activeSurahData.name); setView('intro'); }}
        className="mb-10 relative overflow-hidden rounded-[40px] aspect-[16/10] group cursor-pointer border border-white/10 shadow-[0_30px_60px_-15px_rgba(0,0,0,0.8)] mx-2"
        style={{ backgroundColor: colors.surface }}
      >
        <img src={activeSurahData.art} className="absolute inset-0 w-full h-full object-cover grayscale opacity-60 group-active:grayscale-0 transition-all duration-1000 scale-105" alt="Hero" />
        <div className="absolute inset-0 bg-gradient-to-t from-[#202124] via-transparent to-transparent" />
        <div className="absolute bottom-8 left-8 right-8 flex justify-between items-end">
            <div className="space-y-1">
                <h3 className="text-2xl font-bold" style={{ color: colors.onSurface }}>Al-Baqarah</h3>
                <p className="text-[9px] font-bold uppercase tracking-[0.2em] text-emerald-400/80">Premium Recitation</p>
            </div>
            <div className="text-6xl font-serif text-[#D4AF37] drop-shadow-2xl rtl">البقرة</div>
        </div>
      </div>

      <div className="space-y-4 px-4">
        {surahs.map((s) => (
          <div 
            key={s.id} 
            onClick={() => { setSelectedSurah(s); fetchSurahIntro(s.name); setView('intro'); }} 
            className="group flex justify-between items-center py-5 px-6 rounded-[28px] border border-white/[0.05] shadow-lg transition-all" 
            style={{ backgroundColor: colors.surface }}
          >
            <div className="flex items-center gap-6">
              <span className="text-[11px] font-mono opacity-20 w-4" style={{ color: colors.onSurface }}>{s.id}</span>
              <div>
                <h2 className="text-lg font-normal group-hover:text-emerald-400 transition-colors tracking-tight" style={{ color: colors.onSurface }}>{s.name}</h2>
                <p className="text-[9px] uppercase tracking-widest font-bold mt-1 opacity-30" style={{ color: colors.textDim }}>{s.verses} Verses</p>
              </div>
            </div>
            <div className="text-2xl opacity-20 group-hover:opacity-100 group-hover:text-emerald-500 transition-all font-serif rtl" style={{ color: colors.onSurface }}>{s.arabic}</div>
          </div>
        ))}
      </div>
    </div>
  );

  const renderAzan = () => (
    <div className="animate-in fade-in duration-700 flex flex-col pb-80 px-6 text-center">
      <header className="mb-10 flex items-center justify-between">
        <button onClick={() => setView('home')} className="p-2 bg-white/5 rounded-full opacity-60 hover:opacity-100 transition-all border border-white/5"><ChevronLeft size={22} style={{ color: colors.onSurface }}/></button>
        <div><p className="text-[9px] font-bold tracking-[0.4em] uppercase opacity-40" style={{ color: colors.textDim }}>Washington D.C.</p><h2 className="text-xl font-light" style={{ color: colors.onSurface }}>Azan Timeline</h2></div>
        <div className="w-10"></div>
      </header>

      <div 
        className="text-center mb-16 space-y-3 p-8 rounded-[32px] border border-white/[0.06] shadow-2xl"
        style={{ backgroundColor: colors.surface }}
      >
        <p className="text-[9px] font-black tracking-[0.5em] uppercase text-emerald-500">Upcoming Focus</p>
        <h3 className="text-4xl font-light" style={{ color: colors.onSurface }}>Dhuhr</h3>
        <p className="text-3xl font-serif text-[#D4AF37] opacity-80">الظهر</p>
        <div className="flex gap-4 justify-center py-4 font-mono">
            <div className="flex flex-col items-center"><span className="text-4xl font-extralight tracking-tighter" style={{ color: colors.onSurface }}>{formatTime(timeLeft.hours)}</span><span className="text-[7px] uppercase opacity-40 mt-1 font-sans">Hrs</span></div>
            <span className="text-2xl font-thin opacity-20">:</span>
            <div className="flex flex-col items-center"><span className="text-4xl font-extralight text-emerald-500 drop-shadow-[0_0_10px_rgba(16,185,129,0.3)]">{formatTime(timeLeft.minutes)}</span><span className="text-[7px] uppercase opacity-40 mt-1 font-sans">Min</span></div>
            <span className="text-2xl font-thin opacity-20">:</span>
            <div className="flex flex-col items-center"><span className="text-4xl font-extralight tracking-tighter" style={{ color: colors.onSurface }}>{formatTime(timeLeft.seconds)}</span><span className="text-[7px] uppercase opacity-40 mt-1 font-sans">Sec</span></div>
        </div>
      </div>

      <div className="relative text-left px-2">
        <div className="absolute left-[31px] top-4 bottom-4 w-[1px] bg-white/5" />
        <div className="space-y-6">
          {prayers.map((p, i) => (
            <div 
              key={p.name} 
              className={`flex items-center gap-6 p-4 rounded-[20px] transition-all border border-transparent ${p.status === 'done' ? 'opacity-30' : 'opacity-100'}`}
              style={{ backgroundColor: p.status === 'next' ? colors.surface : 'transparent', borderColor: p.status === 'next' ? 'rgba(255,255,255,0.05)' : 'transparent' }}
            >
              <span className={`text-[10px] font-mono w-10 text-right ${p.status === 'next' ? 'text-emerald-500 font-bold' : ''}`} style={{ color: p.status === 'next' ? colors.emerald : colors.onSurface }}>{p.time}</span>
              
              <div className="relative">
                <div className={`w-2.5 h-2.5 rounded-full border-2 ${p.status === 'done' || p.status === 'next' ? 'bg-emerald-500 border-emerald-500 shadow-[0_0_8px_var(--emerald)]' : 'border-stone-700'}`} />
              </div>

              <div className="flex-1 flex justify-between items-center group">
                <div className="flex flex-col">
                  <span className={`text-xs tracking-widest uppercase ${p.status === 'next' ? 'font-bold' : ''}`} style={{ color: p.status === 'next' ? colors.onSurface : colors.textDim }}>{p.name}</span>
                  <span className={`text-xl font-serif rtl transition-all ${p.status === 'next' ? 'text-emerald-600/80' : 'opacity-20'}`} style={{ color: colors.onSurface }}>{p.arabic}</span>
                </div>
                
                {p.name !== 'Sunrise' && (
                  <button 
                    onClick={() => togglePrayed(p.name)}
                    className={`w-10 h-10 rounded-full flex items-center justify-center border transition-all duration-500 ${prayedLog[p.name] ? 'bg-emerald-600 border-emerald-500 shadow-[0_0_15px_rgba(16,185,129,0.4)]' : 'bg-white/5 border-white/10 hover:bg-white/10'}`}
                  >
                    <Check size={18} className={`transition-all duration-500 ${prayedLog[p.name] ? 'text-white scale-110' : 'text-white/10 scale-90'}`} />
                  </button>
                )}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );

  return (
    <div className="min-h-screen p-4 md:p-8 max-w-md mx-auto font-sans flex flex-col overflow-x-hidden relative" style={{ backgroundColor: colors.bg, color: colors.onSurface }}>
      
      <main className="flex-1">
        {view === 'home' && renderHome()}
        {view === 'library' && renderLibrary()}
        {view === 'intro' && (
           <div className="animate-in slide-in-from-bottom-24 duration-1000 h-full flex flex-col pb-80 relative overflow-hidden bg-[#202124]">
            <div className="absolute inset-0 z-0">
                <img src={selectedSurah?.art || activeSurahData.art} className="w-full h-full object-cover opacity-30 grayscale brightness-75 scale-110" alt="" />
                <div className="absolute inset-0 bg-gradient-to-b from-[#202124] via-[#202124]/40 to-[#202124]" />
            </div>
            <div className="relative z-10 flex-1 flex flex-col px-8 pt-12 text-center">
                <button onClick={() => setView('library')} className="absolute top-12 left-6 p-3 bg-white/5 rounded-full opacity-60 hover:opacity-100 transition-all"><ChevronDown size={28} style={{ color: colors.onSurface }}/></button>
                <div className="flex-1 flex flex-col justify-center items-center gap-12">
                  <div className="space-y-2">
                      <p className="text-[10px] font-black tracking-[0.6em] uppercase text-emerald-500 opacity-60">Chapter {selectedSurah?.id || '2'}</p>
                      <h1 className="text-8xl font-serif text-[#D4AF37] drop-shadow-[0_0_30px_rgba(212,175,55,0.4)]">{selectedSurah?.arabic || 'البقرة'}</h1>
                      <h2 className="text-4xl font-light tracking-tighter" style={{ color: colors.onSurface }}>{selectedSurah?.name || 'Al-Baqarah'}</h2>
                  </div>
                  <div className="flex gap-14 border-y border-white/5 py-10 w-full justify-center">
                      <div className="flex flex-col items-center gap-1.5"><Sunrise size={20} className="opacity-30" /><span className="text-[10px] font-bold uppercase tracking-widest text-stone-400">{selectedSurah?.place || 'Medina'}</span></div>
                      <div className="flex flex-col items-center gap-1.5"><ScrollText size={20} className="opacity-30" /><span className="text-[10px] font-bold uppercase tracking-widest text-stone-400">{selectedSurah?.verses || '286'} Verses</span></div>
                  </div>
                  <div className="max-w-xs space-y-8">
                      <div className="flex items-center justify-center gap-2 mb-2"><Sparkles size={16} className="text-gold" /><span className="text-[10px] font-black uppercase tracking-[0.3em] text-gold opacity-80">Sanctuary Insight</span></div>
                      <p className="text-xl font-light leading-relaxed italic min-h-[5rem] opacity-70" style={{ color: colors.onSurface }}>{aiLoading ? "Gathering Insight..." : `"${surahInsight || "Enter to explore the depths of this Surah."}"`}</p>
                  </div>
                </div>
                <button onClick={() => setView('read')} className="mb-12 w-full py-5 rounded-[30px] bg-emerald-600 text-white font-bold uppercase tracking-[0.4em] text-xs shadow-2xl active:scale-95 transition-all">Enter Sanctuary</button>
            </div>
          </div>
        )}
        {view === 'read' && (
          <div className="animate-in fade-in duration-700 h-full flex flex-col pb-80 relative overflow-hidden">
            <div className="absolute inset-0 z-0"><img src={activeSurahData.readBg} className="w-full h-full object-cover opacity-[0.12] grayscale brightness-75 blur-2xl" alt="" /><div className="absolute inset-0 bg-gradient-to-b from-[#202124] via-transparent to-[#202124]" /></div>
            <header className="relative z-10 flex justify-between items-center mb-16 pt-4 px-4"><button onClick={() => setView('library')} className="p-3 bg-black/40 rounded-full opacity-80 border border-white/5"><ChevronLeft size={22} style={{ color: colors.onSurface }}/></button><h2 className="text-lg font-medium" style={{ color: colors.onSurface }}>{selectedSurah?.name || "Al-Baqarah"}</h2><div className="w-10"></div></header>
            <div className="relative z-10 flex-1 space-y-16 text-right px-6"><h3 className="text-4xl font-serif rtl opacity-30" style={{ color: colors.onSurface }}>بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ</h3><p className="text-5xl font-serif rtl leading-[2.6] drop-shadow-lg" style={{ color: colors.onSurface }}>ذَٰلِكَ <span className="text-emerald-400 bg-emerald-500/20 px-3 rounded-xl border border-emerald-500/30">ٱلْكِتَٰبُ</span> لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ...</p></div>
          </div>
        )}
      </main>

      {/* MINI PLAYER (80px) - LIGHTER SURFACE */}
      {(view !== 'read' && view !== 'intro') && (
        <div className="fixed bottom-[95px] left-1/2 -translate-x-1/2 w-full max-w-md px-4 z-[80] animate-in slide-in-from-bottom-12 duration-700">
            <div 
              onClick={() => { setSelectedSurah(activeSurahData); fetchSurahIntro(activeSurahData.name); setView('intro'); }} 
              className="p-3 pr-5 rounded-[32px] backdrop-blur-3xl border border-white/10 shadow-[0_30px_60px_-15px_rgba(0,0,0,1)] flex items-center gap-4 cursor-pointer group relative overflow-hidden h-[80px]"
              style={{ backgroundColor: 'rgba(53, 54, 58, 0.98)' }}
            >
                <div className="absolute top-1 left-1/2 -translate-x-1/2 w-10 h-1 rounded-full bg-white/10 group-hover:bg-emerald-500/40 transition-all" />
                <div className="w-14 h-14 rounded-2xl overflow-hidden grayscale opacity-60 group-hover:grayscale-0 transition-all shadow-lg border border-white/5"><img src={activeSurahData.art} className="w-full h-full object-cover" alt=""/></div>
                <div className="flex-1 min-w-0"><h5 className="text-sm font-semibold truncate" style={{ color: colors.onSurface }}>Al-Baqarah</h5><p className="text-[10px] font-black opacity-30 uppercase tracking-[0.2em] truncate" style={{ color: colors.textDim }}>Pull up for Insight</p></div>
                <div className="w-10 h-10 rounded-full border border-white/10 flex items-center justify-center opacity-60 hover:opacity-100 bg-white/5 transition-all"><Play size={16} fill={colors.onSurface} color={colors.onSurface} className="ml-0.5" /></div>
                <div className="absolute bottom-0 left-10 right-10 h-1 bg-emerald-500/10 rounded-full overflow-hidden"><div className="h-full bg-emerald-500 transition-all duration-1000" style={{ width: `42%` }} /></div>
            </div>
        </div>
      )}

      {/* NAVIGATION PILL (72px) */}
      <div className="fixed bottom-10 left-1/2 -translate-x-1/2 w-full max-w-md px-4 z-50 pointer-events-none flex justify-center">
        <div className="flex items-center gap-12 px-10 py-3 backdrop-blur-3xl rounded-full border border-white/10 shadow-[0_30px_60px_-15px_rgba(0,0,0,1)] pointer-events-auto h-[72px]" style={{ backgroundColor: 'rgba(28, 28, 28, 0.8)' }}>
          <button onClick={() => setView('home')} className={`transition-all hover:scale-110 ${view === 'home' ? 'text-emerald-500' : 'opacity-30'}`}><Home size={24} strokeWidth={1.5} /></button>
          <div className="relative flex items-center justify-center"><div className="absolute -inset-6 bg-emerald-500/20 blur-3xl rounded-full" /><button onClick={() => { setSelectedSurah(activeSurahData); fetchSurahIntro(activeSurahData.name); setView('intro'); }} className="relative w-12 h-12 rounded-full bg-emerald-600 flex items-center justify-center text-white shadow-xl hover:scale-110 active:scale-95 transition-all border-4 border-[#202124]"><Play size={24} fill="white" className="ml-0.5" strokeWidth={0} /></button></div>
          <button onClick={() => setView('library')} className={`transition-all hover:scale-110 ${view === 'library' || view === 'read' || view === 'intro' ? 'text-emerald-500' : 'opacity-30'}`}><BookOpen size={24} strokeWidth={1.5} /></button>
        </div>
      </div>

      <style dangerouslySetInnerHTML={{ __html: `
        @import url('https://fonts.googleapis.com/css2?family=Amiri:wght@400;700&display=swap');
        .rtl { direction: rtl; }
        ::-webkit-scrollbar { width: 0px; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }
        .animate-in { animation: fadeIn 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
      `}} />
    </div>
  );
};

export default App;