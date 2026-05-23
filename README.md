# Fuel Your Body — Protein & Exercise Website

A simple one-page website about protein and exercise. The website is just one
HTML file. It lives on **AWS S3** (a place on the internet to store files),
and **GitHub Actions** automatically puts it there for you.

Live page title: *"Fuel Your Body — Protein & Exercise"*

---

## What is in this project?

```
web-server/
├── index.html        ← The whole website (one big HTML file)
├── hero-photo.jpg    ← The big picture on top of the page
├── setup-s3.sh       ← Run this ONE time on your laptop to create the S3 bucket
├── .github/
│   └── workflows/
│       ├── deploy.yml   ← Pushes the site to S3 (the "publish" button)
│       └── destroy.yml  ← Deletes the bucket if you want to remove everything
└── README.md         ← You are reading this
```

That's it. No build step. No frameworks. No node_modules. Just HTML + an image.

---

## The big picture (how it all works)

```
   ┌──────────────────┐                     ┌────────────────────┐
   │   Your laptop    │                     │      GitHub        │
   │                  │   git push          │                    │
   │  index.html  ────┼────────────────────►│  your repository   │
   │  hero-photo.jpg  │                     │                    │
   └──────────────────┘                     └─────────┬──────────┘
                                                      │
                                                      │ You click
                                                      │ "Run workflow"
                                                      ▼
                                            ┌────────────────────┐
                                            │  GitHub Actions    │
                                            │   (deploy.yml)     │
                                            │                    │
                                            │  1. Log in to AWS  │
                                            │  2. Make bucket    │
                                            │  3. Upload files   │
                                            └─────────┬──────────┘
                                                      │
                                                      ▼
                                            ┌────────────────────┐
                                            │     AWS S3         │
                                            │  (storage bucket)  │
                                            │                    │
                                            │  vishal-protein-   │
                                            │  fitness-demo      │
                                            └─────────┬──────────┘
                                                      │
                                                      ▼
                                            ┌────────────────────┐
                                            │   Anyone with a    │
                                            │   web browser      │
                                            │                    │
                                            │  Can open the site │
                                            └────────────────────┘
```

**In one line:** You push your code to GitHub → click a button → your site is live.

---

## A note on HTTP vs HTTPS

S3 static hosting serves the site over **plain HTTP**, not HTTPS. Some
browsers show a "Not Secure" warning. For a short demo this is fine — if
Chrome blocks the page, type the letters `thisisunsafe` directly on the
warning screen and it will load.

(If you ever need real HTTPS, you'd put AWS CloudFront in front of S3.
This project deliberately keeps things simple and skips that.)

---

## What you need before starting

You need three things:

1. **An AWS account** (free tier is fine)
2. **A GitHub account** with this code pushed to a repo
3. **AWS Access Keys** stored as GitHub Secrets (see below)

### Setting up AWS keys as GitHub Secrets

Go to your repo on GitHub:

```
Your repo  →  Settings  →  Secrets and variables  →  Actions  →  New secret
```

Add these two secrets:

| Secret name              | What goes in it                          |
|--------------------------|------------------------------------------|
| `AWS_ACCESS_KEY_ID`      | Your AWS access key (starts with "AKIA") |
| `AWS_SECRET_ACCESS_KEY`  | Your AWS secret key (long random string) |

Without these, the deploy will fail because GitHub cannot log in to AWS.

---

## How to deploy (publish) the site

You have **two options**. Pick one — you do not need both.

### Option A — Easiest: click a button on GitHub (recommended)

```
   ┌──────────────────────────────────────────┐
   │ GitHub  →  Actions tab                   │
   │   →  "Deploy to S3" workflow             │
   │       →  Click "Run workflow" button     │
   │           →  Wait ~30 seconds            │
   │               →  Done — URL is shown     │
   └──────────────────────────────────────────┘
```

The workflow will:

1. Check if the S3 bucket exists. If not, create it.
2. Make the bucket readable by everyone (so the world can see your page).
3. Turn on "static website hosting" (so S3 acts like a tiny web server).
4. Upload `index.html` + the image.
5. Print the website URL at the end.

Your site will be at:

```
http://vishal-protein-fitness-demo.s3-website-us-east-1.amazonaws.com
```

### Option B — Do the S3 setup once from your laptop

If you have the AWS CLI on your machine and have run `aws configure`:

```bash
./setup-s3.sh
```

This does the bucket creation **once**. After that, you still use Option A
to upload new versions of your files.

---

## Step-by-step: from zero to a live website

```
  STEP 1                 STEP 2                  STEP 3
  ┌──────┐               ┌──────┐                ┌──────┐
  │ Add  │   ───────►    │ Push │   ───────►     │ Click│
  │ AWS  │               │ code │                │ Run  │
  │ keys │               │ to   │                │ in   │
  │ to   │               │ Git- │                │ Acti-│
  │ Git- │               │ Hub  │                │ ons  │
  │ Hub  │               │      │                │ tab  │
  └──────┘               └──────┘                └──────┘
     │                      │                       │
     ▼                      ▼                       ▼
  Secrets             git push origin main      Site goes live
  saved               (your code is on          You get a URL
                       GitHub now)              that anyone can
                                                visit
```

---

## How to change the website

1. Open `index.html` in any editor (VS Code, Sublime, even Notepad).
2. Change the text, colors, sections — whatever you want.
3. Save the file.
4. Push to GitHub:
   ```bash
   git add index.html
   git commit -m "Updated the protein section"
   git push
   ```
5. Go to **Actions → Deploy to S3 → Run workflow**.
6. Wait ~30 seconds. Refresh your site URL. Done.

> **Note:** Pushing to GitHub by itself does **NOT** deploy. You must click
> "Run workflow" because the trigger is set to `workflow_dispatch` (manual).

---

## How to delete everything (clean up)

If you no longer want the site (and don't want to pay AWS for storage):

```
   ┌──────────────────────────────────────────────────────┐
   │ GitHub  →  Actions  →  "Destroy S3 Bucket"           │
   │   →  Run workflow                                    │
   │       →  Type the bucket name to confirm             │
   │          (vishal-protein-fitness-demo)               │
   │           →  Wait — bucket is emptied and deleted    │
   └──────────────────────────────────────────────────────┘
```

The destroy workflow asks you to **type the bucket name** as a safety check
so you don't delete things by accident.

---

## Why use S3 for a website?

```
   ┌─────────────────────┐         ┌─────────────────────┐
   │   Normal server     │   vs    │      S3             │
   │                     │         │                     │
   │  • Needs uptime     │         │  • No server to run │
   │  • Costs $$$/month  │         │  • Pennies/month    │
   │  • Patch & monitor  │         │  • AWS handles all  │
   │  • Can crash        │         │  • Almost never down│
   └─────────────────────┘         └─────────────────────┘
```

S3 was made for storing files. When you turn on "static website hosting,"
S3 also serves those files like a web server. For a one-page site with no
backend, this is the cheapest and simplest option.

---

## Common problems and fixes

| Problem                                    | What to check                                       |
|--------------------------------------------|-----------------------------------------------------|
| "Access Denied" when visiting the URL      | Bucket policy not applied — re-run the deploy      |
| Workflow fails at "Configure AWS credentials" | Secrets missing or typed wrong in GitHub Settings |
| Bucket name "already exists"               | S3 bucket names are global — pick a unique name in `deploy.yml` and `setup-s3.sh` |
| Changes not showing up                     | Hard-refresh your browser (Cmd+Shift+R / Ctrl+F5)  |
| Deploy succeeds but page is blank          | Make sure `index.html` is at the top level of the repo |
| Browser blocks the page as "Not Secure"    | Type `thisisunsafe` on the warning screen (Chrome/Edge) — the page loads |

---

## Customizing the bucket name

The bucket name `vishal-protein-fitness-demo` is used in 3 places. If you
want your own:

1. `setup-s3.sh` → line 9 (`BUCKET=`)
2. `.github/workflows/deploy.yml` → line 8 (`S3_BUCKET:`)
3. `.github/workflows/destroy.yml` → line 13 (`S3_BUCKET:`)

> Bucket names must be **globally unique** across all of AWS — if someone in
> the world already used the name, you need to pick a different one.

---

## File-by-file: what each thing does

### `index.html`
The whole website. It has:
- A navigation bar at the top
- A big hero section with the title
- Sections on protein, exercise, workouts by body part
- All CSS is inline (inside `<style>` tags) — no extra files needed

### `hero-photo.jpg`
The large background photo at the top of the page.

### `setup-s3.sh`
A one-time script you can run on your laptop to create the S3 bucket.
Optional — the deploy workflow can also create the bucket for you.

### `.github/workflows/deploy.yml`
The GitHub Action that publishes the site. Triggered manually via
"Run workflow" in the Actions tab.

### `.github/workflows/destroy.yml`
The GitHub Action that empties and deletes the bucket. Requires you to
type the bucket name as confirmation.

---

## Cost estimate

For a small personal site like this one:

- **S3 storage:** ~$0.02/month (the files are only a few MB)
- **Data transfer:** Free for the first 100 GB per month
- **GitHub Actions:** Free for public repos

In real life: **less than a coffee per year.** For a short demo where you
deploy and destroy within an hour, the bill is effectively **$0**.

---

## Summary

```
  ┌────────────────────────────────────────────────────┐
  │  1. Put AWS keys in GitHub Secrets                 │
  │  2. Push your code to GitHub                       │
  │  3. Actions tab → Deploy to S3 → Run workflow      │
  │  4. Open the URL shown in the workflow output      │
  │  5. Done — your site is on the internet            │
  └────────────────────────────────────────────────────┘
```

That's the whole thing. Change `index.html`, push, click Run workflow,
refresh your URL. Repeat forever.
