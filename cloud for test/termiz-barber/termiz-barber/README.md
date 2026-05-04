# Termiz Barber — Telegram Mini App

## 📁 Fayl tuzilmasi
```
termiz-barber/
├── index.html              ← Asosiy Mini App (mijoz + admin)
├── sql/
│   └── schema.sql          ← Supabase jadval yaratish SQL
├── .github/
│   └── workflows/
│       └── deploy.yml      ← GitHub Pages auto-deploy
└── README.md
```

---

## 🚀 1-qadam: Supabase sozlash

1. **[supabase.com](https://supabase.com)** ga kiring → **New Project** yarating
2. Project tayyor bo'lgandan keyin:
   - **SQL Editor** → **New Query** → `sql/schema.sql` tarkibini joylashtiring → **Run**
3. **Settings → API** ga o'ting:
   - `Project URL` → nusxa oling
   - `anon public` key → nusxa oling

---

## ⚙️ 2-qadam: index.html ni sozlash

`index.html` faylida pastdagi qatorlarni toping va to'ldiring:

```javascript
const SUPABASE_URL  = 'YOUR_SUPABASE_URL';     // https://xxxx.supabase.co
const SUPABASE_ANON = 'YOUR_SUPABASE_ANON_KEY'; // eyJhbGci...
const ADMIN_IDS     = ['8536944196'];            // Admin Telegram ID lar
const BOT_TOKEN     = '8669240949:AAESNLLcctbfYs55aR0dckNL7yqk7J5Ra-c';
```

---

## 📦 3-qadam: GitHub ga yuklash

```bash
# 1. GitHub da yangi repo yarating (masalan: termiz-barber)

# 2. Terminalda:
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/SIZNING_USERNAME/termiz-barber.git
git push -u origin main
```

---

## 🌐 4-qadam: GitHub Pages yoqish

1. GitHub repo → **Settings** → **Pages**
2. **Source**: `GitHub Actions` tanlang
3. Bir necha daqiqadan keyin sayt tayyor bo'ladi:
   ```
   https://SIZNING_USERNAME.github.io/termiz-barber/
   ```

---

## 🤖 5-qadam: Telegram Bot sozlash

### BotFather da:
```
/setmenubutton
```
Botingizni tanlang → **Web App URL** → GitHub Pages URL ingizni kiriting

### Mini App URL ni o'rnatish:
```
/newapp
```
Yoki mavjud botga:
```
/setmenubutton → Web App → https://USERNAME.github.io/termiz-barber/
```

---

## 👤 Admin kirishi

Bot `telegram_id = 8536944196` bo'lgan foydalanuvchiga avtomatik **Admin Panel** ko'rsatadi.

Qo'shimcha admin qo'shish uchun:
- Admin paneliga kiring → **Adminlar** bo'limi → **+ Admin qo'shish**
- Yoki `sql/schema.sql` da:
  ```sql
  INSERT INTO admins (telegram_id, name) VALUES ('TELEGRAM_ID', 'Ism');
  ```

---

## 🔄 Yangilanishlar

`index.html` ni o'zgartirgan har safar:
```bash
git add .
git commit -m "Update"
git push
```
GitHub Actions avtomatik deploy qiladi (~1 daqiqa).

---

## 📊 Supabase jadvallar

| Jadval | Maqsad |
|--------|--------|
| `barbers` | Masterlar ro'yxati |
| `services` | Xizmatlar va narxlar |
| `bookings` | Barcha navbatlar |
| `settings` | Salon sozlamalari |
| `admins` | Admin Telegram ID lar |

---

## ⚡ Xususiyatlar

### Mijoz paneli:
- ✅ Telegram ID orqali avtomatik login
- ✅ Masterlar va xizmatlarni ko'rish (Supabase dan)
- ✅ 4 bosqichli navbat olish
- ✅ O'z navbatlar tarixini ko'rish
- ✅ Admin ga Telegram xabar yuborish (bot orqali)

### Admin paneli (faqat `8536944196`):
- ✅ Dashboard — statistika, grafik, faoliyat
- ✅ Navbatlar — ko'rish, tasdiqlash, bekor qilish, o'chirish
- ✅ Masterlar — qo'shish, tahrirlash, faol/nofaol
- ✅ Xizmatlar — qo'shish, narx, davomiylik
- ✅ Mijozlar — bazasi, statistika
- ✅ Sozlamalar — salon ma'lumotlari, ish vaqti
- ✅ Adminlar — qo'shish, o'chirish

---

## 🛠 Muammo yechish

**"Supabase ulanmayapti"** → URL va ANON key ni tekshiring

**"Admin panel ko'rinmayapti"** → Telegram ID ni tekshiring (`8536944196` to'g'ri ekanligini)

**"Bot xabar yubormayapti"** → Bot token va admin Telegram ID ni tekshiring

**Dev mode** → Brauzerda ochganda ID so'raladi, `8536944196` kiriting = admin panel
