# PRD — GajiMeter Privacy Policy Page

**Requested by:** Developer  
**Assigned to:** Designer  
**Priority:** CRITICAL — Play Store submission is blocked until this is live  
**Due:** Before first Play Store submission  

---

## 1. Background & Why This Exists

GajiMeter is a salary tracker app for Malaysian workers. It uses **Google AdMob** to serve ads and handles **sensitive personal data** (salary, expenses, payday date).

Google Play Store has two hard rules:
1. Any app using AdMob **must** link to a live privacy policy from the Store listing.
2. Any app collecting personal/financial data **must** disclose it clearly.

Without this page live on the internet, the app **will be rejected** by Google Play. This is not optional.

---

## 2. What Needs to Be Delivered

Two things:

| # | Deliverable | Format | Where it lives |
|---|-------------|--------|----------------|
| 1 | Privacy Policy **web page** | HTML or hosted page (e.g., GitHub Pages, Notion, simple website) | Must have a public URL (e.g. `gajimeter.github.io/privacy`) |
| 2 | Privacy Policy **in-app screen** *(optional but nice)* | Flutter screen or WebView | Launched when user taps Privacy Policy in Settings |

The **web page** is the blocker. The in-app screen can come later.

---

## 3. Required Content (Legal)

The privacy policy page **must** include all of the following sections. Content is pre-written below — designer just needs to format and style it.

---

### 3.1 App Info Header

```
App Name:     GajiMeter
Developer:    [Your Name / Company Name]
Contact:      [your@email.com]
Effective:    [Date you publish this]
```

---

### 3.2 Data We Collect

Use a table or clear list. GajiMeter collects:

| Data | Where stored | Shared with anyone? |
|------|-------------|---------------------|
| Monthly salary (entered by user) | Device only (SharedPreferences) | No |
| Work hours & work days setting | Device only | No |
| Payday date | Device only | No |
| Monthly expense items | Device only | No |
| Work session history | Device only | No |
| App theme & language preference | Device only | No |

**Note:** All user data is stored locally on the device. GajiMeter has **no servers, no accounts, and no cloud sync.** We never upload your salary or expense data anywhere.

---

### 3.3 Third-Party Services (AdMob)

This is the most important section for Google compliance.

```
GajiMeter uses Google AdMob to display advertisements.

AdMob may collect:
- Advertising ID (GAID on Android)
- Device information (OS version, device model)
- Approximate location (country/region level)
- Ad interaction data (views, clicks)

This data is collected and processed by Google LLC under their own 
Privacy Policy: https://policies.google.com/privacy

You can opt out of personalized ads via your device settings:
  Android: Settings → Google → Ads → Opt out of Ads Personalization
```

---

### 3.4 Permissions

GajiMeter does **not** request:
- Camera, microphone, contacts, location, SMS, or call access

The only permission used is internet access (required for ads).

---

### 3.5 Children's Privacy

```
GajiMeter is not directed at children under 13. 
We do not knowingly collect data from children.
```

---

### 3.6 Changes to This Policy

```
We may update this Privacy Policy from time to time. 
Changes will be posted on this page with an updated effective date.
Continued use of the app after changes means you accept the new policy.
```

---

### 3.7 Contact

```
If you have any questions about this Privacy Policy, contact us at:
[your@email.com]
```

---

## 4. Design Requirements

### 4.1 Visual Style

| Property | Requirement |
|----------|-------------|
| Tone | Clean, trustworthy, minimal |
| Language | **Bilingual: Bahasa Malaysia + English** (side by side or toggle) |
| Brand colors | GajiMeter primary: `#10B981` (Emerald Green), `#3B82F6` (Blue) |
| Font | Inter (same as app) or any clean sans-serif |
| Mobile-first | Must be readable on a phone browser |

### 4.2 Page Structure (Top to Bottom)

```
┌─────────────────────────────────────┐
│  GajiMeter Logo + "Privacy Policy"  │
│  Effective date                      │
├─────────────────────────────────────┤
│  1. Data We Collect                  │
│  2. How We Use Your Data            │
│  3. Third-Party Services (AdMob)    │
│  4. Permissions                      │
│  5. Children's Privacy              │
│  6. Changes to This Policy          │
│  7. Contact Us                      │
├─────────────────────────────────────┤
│  Footer: © GajiMeter · Made in 🇲🇾  │
└─────────────────────────────────────┘
```

### 4.3 Language Toggle (Nice to Have)

A simple toggle or tab at the top to switch between:
- **BM** — Bahasa Malaysia (default)
- **EN** — English

If time is limited, English only is acceptable. Google Play accepts English privacy policies for Malaysian apps.

---

## 5. Hosting Options (Pick One)

| Option | Effort | Cost | Notes |
|--------|--------|------|-------|
| GitHub Pages | Low | Free | Push HTML file to repo, enable Pages — done in 10 min |
| Notion public page | Very low | Free | Publish a Notion doc — instant, but less polished |
| Carrd / Webflow | Low | Free tier available | Looks great, drag-and-drop |
| Own domain | Medium | Paid | e.g. `privacy.gajimeter.com` — best long-term |

**Recommendation:** GitHub Pages for speed. Domain can be added later.

---

## 6. What Developer Needs from Designer

Once the page is live, developer needs:

- [ ] The final **public URL** of the privacy policy page
- [ ] Confirmation it loads correctly on mobile browser
- [ ] (Optional) An in-app Flutter-ready version or WebView URL

Developer will then:
1. Replace the "coming soon" snackbar in `lib/main.dart:4300` with `launchUrl(Uri.parse('YOUR_URL'))`
2. Paste the URL into the Google Play Console → Store Listing → Privacy Policy URL field

---

## 7. Acceptance Criteria

- [ ] Page is publicly accessible via a URL (no login required)
- [ ] Page includes all 7 sections from Section 3 above
- [ ] AdMob disclosure is clearly present
- [ ] Page is readable on mobile
- [ ] URL is shared with developer

---

## 8. Out of Scope

- GDPR consent banner (not required for Malaysia-only launch)
- In-app privacy settings screen (Phase 2)
- Terms of Service (separate document, not a Play Store blocker)
