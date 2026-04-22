# Dockerfile Types — Explained Simply

---

## 📦 1. Basic Dockerfile (Single Stage)

**What it is:** One single file, one single image. You build your app AND run it from the same image.

**How it works:**
- Start from a base image (e.g. `node:20` or `ubuntu`)
- Install all dependencies
- Copy your source code
- Build your app
- Run it — all in the same layer

**Key points:**
- Everything lands in the final image — compilers, build tools, npm, source code, test files, everything
- Super easy to write and understand
- Great for learning, local development, and quick testing
- Terrible for production — image size can reach **900MB to 1.5GB**
- Huge security risk because attackers can find build tools, shell access, and leftover secrets inside the image
- If your app gets compromised, the attacker has a full toolkit available

**Best for:** Learning Docker, local dev, quick prototypes

---

## 🔀 2. Multistage Dockerfile

**What it is:** One Dockerfile, but split into two (or more) stages — a **build stage** and a **run stage**.

**How it works:**
- **Stage 1 (Builder):** Use a full image to install dependencies and compile/build your app
- **Stage 2 (Runner):** Start fresh from a slim base image and copy **only the built output** from Stage 1
- The builder stage is thrown away after the build — it never ships

**Key points:**
- Build tools, compilers, and source code are **not** in the final image
- Final image is much smaller — typically **150MB to 400MB**
- Much lower attack surface compared to basic Dockerfile
- The final image still has a full OS (Linux distro like Debian/Alpine) with a shell, package manager, and OS-level utilities
- Slightly more complex to write, but considered **standard best practice** for production
- If something breaks in production, you can still `docker exec` into the container and debug using the shell

**Best for:** Most production applications, APIs, web services

---

## 🔒 3. Distroless Multistage Dockerfile

**What it is:** Same two-stage idea as multistage, but the **final runtime image contains absolutely no operating system** — no shell, no package manager, no Linux utilities. Just your app and the language runtime.

**How it works:**
- **Stage 1 (Builder):** Exactly same as multistage — full image to build your app
- **Stage 2 (Runner):** Uses a Google `distroless` image (e.g. `gcr.io/distroless/nodejs20`) which strips everything except the bare runtime
- You copy only your compiled app into this empty shell of an image

**Key points:**
- No shell (`bash`, `sh`) inside the container — nobody can exec into it
- No `apt`, `apk`, or any package manager — nothing can be installed at runtime
- Fewest possible CVEs (security vulnerabilities) because there are almost no packages to exploit
- Smallest image size — typically **50MB to 120MB**
- Hardest to debug — if something goes wrong in production, you have no tools to inspect it (Google provides a special `:debug` tag with a minimal shell for emergencies)
- Requires you to be very precise about what files you copy into the final image
- Not all languages have an official distroless base image

**Best for:** High-security environments, microservices, fintech, healthcare, anything in regulated industries

---

## 🆚 Side-by-Side Summary

| Feature | Basic | Multistage | Distroless Multistage |
|---|---|---|---|
| Build Stages | 1 | 2 | 2 |
| Image Size | ~900MB–1.5GB | ~150–400MB | ~50–120MB |
| Has Shell | ✅ Yes | ✅ Yes | ❌ No |
| Has Package Manager | ✅ Yes | ✅ Yes | ❌ No |
| Source Code in Image | ✅ Yes | ❌ No | ❌ No |
| Build Tools in Image | ✅ Yes | ❌ No | ❌ No |
| Security Risk | 🔴 High | 🟡 Medium | 🟢 Minimal |
| Debuggable | ✅ Easy | ✅ Easy | ⚠️ Very Hard |
| Production Ready | ❌ No | ✅ Yes | ✅ Yes |
| Complexity | Low | Medium | High |

---

## 🧠 Simple Rule to Remember

> **Basic** = You ship your entire kitchen to the restaurant just to serve one dish.
>
> **Multistage** = You cook in the kitchen, then only bring the dish to the table.
>
> **Distroless** = You bring the dish, but the table has no cutlery, no napkins, no condiments — nothing that could be misused.
