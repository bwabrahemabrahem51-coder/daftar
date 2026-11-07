# دفتر الديون — دليل الرفع والتثبيت

## محتويات المجلد
| الملف | شنو هو |
|---|---|
| `index.html` | التطبيق نفسه (الخطوط مدمجة فيه) |
| `manifest.webmanifest` | يخلي المتصفح يعتبره تطبيق قابل للتثبيت |
| `sw.js` | يخلي التطبيق يشتغل بدون إنترنت |
| `icon-192.png` `icon-512.png` `icon-maskable-512.png` `apple-touch-icon.png` | أيقونة التطبيق |
| `.github/workflows/deploy.yml` | ملف Actions: ينشر التطبيق تلقائياً على GitHub Pages |
| `.github/workflows/build-apk.yml` | ملف Actions: يبني ملف APK (Run workflow يدوياً) |
| `supabase.sql` | ينشئ جدول `entries` مع حماية RLS (يشغَّل مرة وحدة بـ Supabase) |

مسار ملف Actions لازم يكون بالضبط: `.github/workflows/deploy.yml`

---

## 1) إنشاء المستودع
1. ادخل github.com وسجّل دخول (أو سوِّ حساب).
2. اضغط **+** ثم **New repository**.
3. الاسم: `daftar` مثلاً (حروف إنكليزية بدون مسافات). اختر **Public**، ولا تضيف README.
4. اضغط **Create repository**.

> لازم Public، لأن GitHub Pages المجاني ما يشتغل مع المستودعات الخاصة.
> هذا مو مشكلة: الكود ما يحتوي بيانات الناس. بياناتهم بـ Supabase ومحمية بقاعدة البيانات.

## 2) رفع الملفات
1. بصفحة المستودع اضغط **uploading an existing file** (أو **Add file → Upload files**).
2. اختر **كل الملفات** من المجلد **ما عدا** مجلد `.github` (يعني: index.html و sw.js و manifest.webmanifest والأربع صور).
3. اضغط **Commit changes**.

> على الموبايل: الرفع يكون بتحديد ملفات، مو مجلدات. لهذا السبب الملفات كلها بنفس المستوى.

## 3) إنشاء ملف Actions
1. **Add file → Create new file**.
2. بخانة الاسم اكتب بالضبط: `.github/workflows/deploy.yml`
   (لما تكتب `/` ينشأ المجلد تلقائياً).
3. افتح ملف `deploy.yml` من المجلد، انسخ كل محتواه والصقه.
4. اضغط **Commit changes**.

## 4) تفعيل GitHub Pages
1. **Settings → Pages**.
2. تحت **Build and deployment**، خلّي **Source = GitHub Actions**.

## 5) النشر
1. افتح تبويب **Actions**. راح تشوف تشغيل اسمه *Deploy to GitHub Pages*.
2. إذا طلع ✅ أخضر، التطبيق منشور. وإذا ما اشتغل تلقائياً: ادخل عليه واضغط **Run workflow**.
3. الرابط يكون:
   `https://اسم-حسابك.github.io/اسم-المستودع/`
   وتلكاه أيضاً داخل Actions بنهاية التشغيل.

## 6) ربط Supabase
**الطريقة الأسهل (بدون ما تعدل الكود):**
1. بالمستودع: **Settings → Secrets and variables → Actions → تبويب Variables → New repository variable**.
2. سوِّ متغيرين:
   - `SUPABASE_URL` = رابط المشروع (Project URL)
   - `SUPABASE_ANON_KEY` = المفتاح العام (anon public key)
3. **Actions → Deploy to GitHub Pages → Run workflow**.

**بـ Supabase:**
- **Authentication → URL Configuration**: حط رابط التطبيق بخانة **Site URL**، وأضفه بـ **Redirect URLs**.
- **Authentication → Email Templates → Magic Link**: أضف سطر `رمز الدخول: {{ .Token }}`.
- اربط **SMTP** (مثل Brevo أو Resend) حتى ما تتحدد رسائل الإيميل.

> لا تحط مفتاح `service_role` بأي مكان نهائياً.

## 7) التثبيت على التلفون
- **آيفون:** افتح الرابط بـ **Safari** ← زر المشاركة ← **إضافة إلى الشاشة الرئيسية**.
- **أندرويد:** افتح الرابط بـ **Chrome** ← النقاط الثلاث ← **تثبيت التطبيق**.

افتحه مرة وحدة وأنت متصل بالنت، حتى ينحفظ للعمل أوفلاين.

> آيفون: رابط الدخول من الإيميل يفتح بـ Safari مو بالتطبيق المثبّت. سجّل دخولك من داخل التطبيق بكتابة **الرمز** اللي بالإيميل.

## 8) التحديث لاحقاً
1. بالمستودع افتح الملف (مثلاً `index.html`) ← **قلم التعديل** أو **Add file → Upload files** بنفس الاسم.
2. **Commit changes**. النشر يصير تلقائياً بدقيقة تقريباً.
3. على التلفون: سكّر التطبيق وافتحه مرتين حتى ينزل التحديث.

## إذا صار خطأ
- **Actions ما اشتغلت:** تأكد أن **Settings → Pages → Source = GitHub Actions**.
- **الصفحة 404:** انتظر دقيقتين بعد أول نشر، وتأكد من الرابط (فيه اسم المستودع بآخره).
- **شاشة الدخول تكتب «غير مربوط بعد»:** المتغيرات ناقصة أو ما سويت **Run workflow** بعدها.
- **الأيقونة ما تغيرت:** احذف التطبيق من الشاشة الرئيسية وثبّته من جديد.

---

## التسجيل والتخزين السحابي
- التسجيل: إيميل + كلمة مرور، وبعدها رمز تحقق يوصل للإيميل.
- لازم بـ Supabase: **Authentication → Email Templates**، أضف `رمز التحقق: {{ .Token }}` لقالبي **Confirm signup** و **Reset Password**.
- شغّل `supabase.sql` بـ **SQL Editor** مرة وحدة. بعدها الديون تنحفظ بالسحابة لكل حساب.

## بناء APK
**Actions → Build APK → Run workflow**، ثم نزّل `daftar-apk` من Artifacts.
