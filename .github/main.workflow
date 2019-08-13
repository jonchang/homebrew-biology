workflow "Run brew test-bot on push" {
  on = "push"
  resolves = ["brew test-bot"]
}


action "brew test-bot" {
  uses = "docker://linuxbrew/brew"
  runs = ".github/main.workflow.sh"
}
