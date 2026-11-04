#!/usr/bin/env bash
#
#   _        _     _                                _
#  / \   ___| |__ (_) _____   _____ _ __   __ _  __| |_ ___  _ __
# / _ \ / __| '_ \| |/ _ \ \ / / _ \ '_ \ / _` |/ _` __/ _ \| '__|
#/ ___ \ (__| | | | |  __/\ V /  __/ | | | (_| | (_| || (_) | |
#\_/ \_\___|_| |_|_|\___| \_/ \___|_| |_|\__,_|\__,_| \___/|_|
#
# ACHIEVENATOR
# "I'll be merge."
#
# Version: v2026.11.04.1453   (datestamp: vYYYY.MM.DD.HHMM of the last edit)
# By Scott McQueen
#
#                          .
#                         /|
#                        / |
#                       /  |
#                      /   |
#              _____.-'    `-.______
#       _.---''                      ``--..__
#    ,-'                                      ``-._
#   /  o                                           `-.      /|
#  <       ,                                          `-.__/ |
#   \    ,/ \     ///                                         |
#    `-._\/\/\/\/\.__                                    __.-'|
#        ``--.._     ``--.._____..-.._____.-----...--''''     \
#               ``--..__                         __..--''`.    \
#                       ```----------------'''''          `-.__|
#
#   (the shark you are about to earn. Note the teeth. Respect the teeth.)
#
# ============================================================================
# MISSION BRIEFING
# ============================================================================
# Somewhere in a data centre, a tiny cartoon shark is waiting to be yours.
# You could earn it the traditional way: years of dedicated open source work,
# thoughtful code reviews, and building things people actually use.
#
# Or you could run a bash script on a Wednesday afternoon.
#
# We respect your time. It is the 80s action-hero way: no long speeches, one
# cool line, then somebody walks away from an explosion without looking at it.
#
# WHAT THIS DOES
#   Builds a public sandbox repo, then makes you the most prolific
#   contributor in the history of a project with exactly one contributor.
#   Think of it as Commando, but the one-man army is a bash script and the
#   enemy is an empty trophy cabinet.
#
# A BRIEF HISTORY OF THE ACHIEVEMENT
#   GitHub looked at developers, a species famous for obsessively optimising
#   everything, and said: "What if we gave them tiny medals?" And lo, the
#   entire profession fell for it. Engineers who will not click a button
#   without reading the changelog will cheerfully merge sixteen PRs for a
#   shark. We are not above this. We are barely above a pigeon being trained
#   to peck a lever, and the pigeon at least gets seeds.
#
# THE USEFULNESS OF ACHIEVEMENTS, A SCIENTIFIC ASSESSMENT
#   Improves your code:            no
#   Impresses recruiters:          they will see a shark and think "aquarium"
#   Impresses your mum:            only if you explain it for forty minutes
#   Fits on a CV:                  please do not
#   Gives a small dopamine hit:    unreasonably, yes
#   Verdict:                       10/10, would collect again
#
#   Statler and Waldorf, watching from the balcony, would give this script
#   one star and then stay for the whole thing anyway. That is the Muppet
#   Theatre review standard, and we hold ourselves to it.
#
# BADGES TARGETED
#   Pull Shark   Merge pull requests. Default 16 gets tier two. Nothing says
#                "senior engineer" like approving your own homework sixteen
#                times in a row and calling it velocity. Merge like Animal
#                on the drums: loudly, repeatedly, and with no plan.
#   YOLO         Merge a PR with no review. At work this is a "quick chat
#                with HR". Here it is a trophy. Peer review is for people
#                with peers; we have a sandbox and a dream. It is also the
#                Black Knight approach to code quality: "'Tis but a scratch."
#   Quickdraw    Close an issue or PR within five minutes. The only time in
#                history a ticket was resolved faster than someone could say
#                "can we circle back on that next sprint". Dane Cook stage
#                energy: in, shout everything at full volume, out, gone.
#
# BADGES DELIBERATELY NOT TARGETED
#   Starstruck, Galaxy Brain, Heart On Your Sleeve, Open Sourcerer
#                These require other human beings to like you, answer you,
#                or merge you. Faking that means fake accounts and spam, and
#                getting banned over a cartoon is a hell of a way to lose a
#                GitHub account. Nobody expects the Spanish Inquisition, but
#                GitHub's trust and safety team does, in fact, expect this.
#                Be popular the old way: be useful.
#   Pair Extraordinaire
#                Needs a real co-author. Bribe a friend with a coffee. It is
#                the only badge here that requires being nice to someone.
#                Even the Terminator needed Sarah Connor to say "come with me".
#   Arctic Code Vault, Mars 2020
#                Limited-time relics. Your code is not in a mountain, and
#                it is not on Mars. Yet. We are not Matt Damon. We do not
#                have the potatoes for it.
#   Public Sponsor
#                Costs actual money. We are here for free glory, thank you.
#
# LLAMA CORNER
#   Why is there no Llama badge? GitHub, the llamas are right there. Imagine
#   a "Llama Drama" achievement for the self-merged PR that starts a feud in
#   the comments, with spitting, neck-craning, and one very judgmental stare.
#   This script contains zero llamas and is worse for it. Spit happens.
#   (Winamp knew. Winamp always knew. It really did whip something, and the
#   rest of us have been catching up ever since.)
#
# USAGE
#   ./achievenator.sh [repo-name] [merged-pr-count]
#   ./achievenator.sh achievements-sandbox 16
#
# YOU NEED
#   git, gh (logged in), and your usual git identity and signing. Commits are
#   signed by 1Password if signing is on, so every meaningless commit is at
#   least cryptographically authentic. Provenance matters, even for nonsense.
#
# SIDE EFFECTS MAY INCLUDE
#   A smug feeling, a cluttered activity feed, mild Beaker-style panicking
#   when a push fails, and the quiet knowledge that a shark is judging you.
#   Spam is also an option in the Monty Python sense: lovely, lovely, spam.
# ============================================================================

set -euo pipefail

VERSION="v2026.11.04.1453"
BYLINE="by Scott McQueen"

show_banner() {
  cat <<'EOF'
                         .
                        /|
                       / |
                      /  |
                     /   |
             _____.-'    `-.______
      _.---''                      ``--..__
   ,-'                                      ``-._
  /  o                                           `-.      /|
 <       ,                                          `-.__/ |
  \    ,/ \     ///                                         |
   `-._\/\/\/\/\.__                                    __.-'|
       ``--.._     ``--.._____..-.._____.-----...--''''     \
              ``--..__                         __..--''`.    \
                      ```----------------'''''          `-.__|

          A C H I E V E N A T O R
EOF
  echo "   ${VERSION}  ${BYLINE}"
  echo
}

REPO_NAME="${1:-achievements-sandbox}"
PR_COUNT="${2:-16}"
MAX_PRS=32          # Pull Shark gold wants 1024 PRs. We have a life.
                    # A small one. Mostly vans and cameras. But still.
                    # And 32 is the tasteful limit, a bit like stopping
                    # Gremlins fans at "just do not feed them after midnight".
PAUSE=6             # Seconds between actions. GitHub's abuse detection has
                    # the sense of humour of a tax audit, so we pace
                    # ourselves like a person, not a toaster with ambitions.
                    # Think Predator: patient, quiet, and mostly in the trees.
WORKDIR="${HOME}/Downloads/${REPO_NAME}"

# Error handler: complain loudly, then leave. Very human of us.
# Beaker would say "meep" here. We say something slightly more helpful.
die() { echo "Achievenator refuses: $*" >&2; exit 1; }

show_banner

# --- Pre-flight checks, or "did you actually install the things" ------------
# This is the Top Gun briefing: check everything twice, then shout "I feel
# the need" at the terminal. The terminal does not care. It never does.
command -v git >/dev/null || die "git is not installed. Bold strategy for a git script."
command -v gh  >/dev/null || die "gh is not installed. Try 'brew install gh' and a long hard look in the mirror."
gh auth status >/dev/null 2>&1 || die "run 'gh auth login' first. Even robots have to sign in."

[[ "$PR_COUNT" =~ ^[0-9]+$ ]] || die "merged-pr-count must be a number. Letters are not pull requests, and we will not be saying Ni to you for this."
(( PR_COUNT >= 1 && PR_COUNT <= MAX_PRS )) || die "merged-pr-count must be 1-${MAX_PRS}. Touch some grass. Preferably llama-adjacent grass."

OWNER="$(gh api user --jq .login)"
GIT_NAME="$(git config --global user.name || true)"
GIT_EMAIL="$(git config --global user.email || true)"
[[ -n "$GIT_NAME" && -n "$GIT_EMAIL" ]] || die "set git user.name and user.email first. Who is committing, a ghost? Who you gonna call?"

# GitHub will not publish a private email. Admirable. We refuse to make
# GitHub reject us after 16 PRs of work, so we check up front.
[[ "$GIT_EMAIL" == *"@users.noreply.github.com" ]] || \
  die "git user.email must be your GitHub noreply address (your account blocks pushes that expose a private email)"

echo "ACHIEVENATOR ONLINE. Come with me if you want to merge."
echo "Target: a PUBLIC repo at ${OWNER}/${REPO_NAME}"
echo "  - ${PR_COUNT} pull requests, opened and merged by you, for you, about you"
echo "  - 1 issue, opened and closed faster than a politician's promise"
echo "  - 1 pull request, opened and closed unmerged, out of pure spite"
echo "Commits will say: ${GIT_NAME} <${GIT_EMAIL}>"
read -r -p "Proceed with the glorious nonsense? [y/N] " answer
[[ "$answer" == "y" || "$answer" == "Y" ]] || { echo "Cancelled. Wisdom prevails. The shark will wait, and so will the llamas."; exit 0; }

# --- Step 1: the repo --------------------------------------------------------
# Must be public, because GitHub ignores private repos for badges. A touching
# little bit of gatekeeping: you can only be celebrated for work the world
# can see. Your private-by-default rule is on a short holiday. It will be back,
# like Arnie, only with fewer one-liners and more license files.
if [[ -e "$WORKDIR" ]]; then die "${WORKDIR} already exists. One sandbox is plenty."; fi
gh repo create "${OWNER}/${REPO_NAME}" --public \
  --description "Sandbox for practising pull request and issue workflows" \
  --license mit --add-readme --clone=false
gh repo edit "${OWNER}/${REPO_NAME}" --add-topic sandbox --add-topic git-workflow \
  --delete-branch-on-merge >/dev/null

git clone "git@github.com:${OWNER}/${REPO_NAME}.git" "$WORKDIR" 2>/dev/null \
  || git clone "https://github.com/${OWNER}/${REPO_NAME}.git" "$WORKDIR"
cd "$WORKDIR"
BASE="$(git symbolic-ref --short HEAD)"
mkdir -p log

# Opens a pull request containing one tiny file. The contents are a log entry
# with the information density of a fortune cookie. Quality was never the
# point. This is the Swedish Chef of commits: lots of noise, no discernible
# ingredients, and somehow it still produces a meal. Bork bork bork.
make_pr() {   # $1 = branch, $2 = title, $3 = body, $4 = file
  git checkout -q -b "$1" "$BASE"
  printf '%s\n' "$3" > "$4"
  git add "$4"
  git commit -q -m "$2"
  git push -q -u origin "$1"
  gh pr create --base "$BASE" --head "$1" --title "$2" --body "$3" >/dev/null
}

# --- Step 2: Pull Shark + YOLO -----------------------------------------------
# Open a PR, then merge it yourself with zero review. At a real company this
# is a stern meeting and an awkward Slack message. On GitHub it is a shark.
# Same behaviour, wildly different HR outcome. Marty McFly merged at 88 mph;
# we merge at whatever speed the PAUSE variable allows, which is a lot less
# dramatic but also a lot less likely to need a flux capacitor.
#
# Each merge gets its own joke, printed to your terminal only, never to the
# repo. There are 16 on file. If you ask for more than 16 PRs, the jokes
# loop back around, like a Monty Python sketch that refuses to end.
JOKES=(
  "Statler: That PR was terrible. Waldorf: Then merge it again, I want to see it fail properly. Hohoho."
  "Animal has entered the repo. MERGE. MERGE. MERGE. Nobody argued."
  "Llama drama: this PR was merged amid spitting, neck-craning and one deeply judgmental stare."
  "Nobody expects the Spanish Inquisition, but this PR fully expected you to approve it."
  "Dane Cook would shout this commit message from the back of an arena and still skip the review."
  "I'll be back. In the next PR. With a slightly different filename."
  "Game over, man. Actually no, game very much on, the merge button still works."
  "Kermit: It's not easy being merged. Miss Piggy: Hiii-YA, approved. Nobody asked her."
  "Marty McFly would merge this at 88 mph. We are doing about six seconds per PR. Great Scott, that is slow."
  "Beaker: Meep meep meep meeeep. Translation: there is no merge conflict. There never was."
  "Yippee-ki-yay, merge-er. Die Hard, but with fewer windows and more markdown."
  "A llama walks into a repo. Nobody reviews the PR. The llama merges it anyway. Spit happens."
  "All those commits will be lost in time, like tears in rain. Time to push."
  "This PR is not dead yet. It is feeling much better. It would like to go for a walk."
  "Swedish Chef: Bork bork bork. Translation: one tiny file, merged with enormous confidence."
  "Always look on the bright side of life. Also always look at the diff. We did neither."
)

for i in $(seq 1 "$PR_COUNT"); do
  n="$(printf '%02d' "$i")"
  make_pr "sandbox/entry-${n}" "Add log entry ${n}" "Log entry ${n}, $(date -u +%Y-%m-%d)." "log/entry-${n}.md"
  sleep "$PAUSE"
  gh pr merge "sandbox/entry-${n}" --merge --delete-branch >/dev/null
  git checkout -q "$BASE"
  git pull -q --ff-only
  echo "Merged PR ${i}/${PR_COUNT}: ${JOKES[$(( (i - 1) % ${#JOKES[@]} ))]}"
  sleep "$PAUSE"
done

# --- Step 3: Quickdraw, issue edition ----------------------------------------
# File a bug and close it a heartbeat later. Fastest resolution time ever
# recorded, achieved by reporting a problem that did not exist. Management
# would call this "proactive". Management would be wrong, but promoted.
# Robocop would say: "Dead or alive, you are closing with me."
ISSUE_URL="$(gh issue create --title "Quickdraw test" --body "Opened and closed straight away. Problem solved, probably.")"
sleep "$PAUSE"
gh issue close "$ISSUE_URL" --reason completed >/dev/null
echo "Issue opened and closed. Fastest gun in the repo. Game over, man. Game over."

# --- Step 4: Quickdraw, pull request edition ---------------------------------
# Open a PR, then slam the door on it. The code never stood a chance. No
# review, no feedback, no closure. It is basically a startup. It is also
# Kermit's face at the end of a Muppet show: delighted, then sudden chaos,
# then credits.
make_pr "sandbox/quickdraw" "Quickdraw test" "Opened and closed straight away." "log/quickdraw.md"
sleep "$PAUSE"
gh pr close "sandbox/quickdraw" --delete-branch >/dev/null
git checkout -q "$BASE"
echo "Pull request opened and closed. It never even got a code review. It's just a flesh wound."

echo
echo "MISSION COMPLETE. Badges usually turn up within a few hours, sometimes a day."
echo "Do NOT delete the repo. Deleting it can take the activity, and your trophies, with it."
echo "Go and admire your tiny cartoon medals: https://github.com/${OWNER}/${REPO_NAME}"
echo "Hasta la vista, backlog. Always look on the bright side of life."
