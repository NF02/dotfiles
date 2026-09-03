# ░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀░░░░█▀█░█░█
# ░█░░░█░█░█░█░█▀▀░░█░░█░█░░░░█░█░█░█
# ░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀░░▀░▀░▀▀▀

$env.config = {
    show_banner: false
}

def git_branch_name [] {
    let branch = (do { git branch --show-current } | complete | get stdout | str trim)
    if ($branch | is-empty) { "" } else { $" ($branch)" }
}

def prompt [] {
    $"(ansi cyan_bold)($env.USER)(ansi reset)@(ansi green_bold)(hostname | str trim)(ansi reset):(ansi yellow_bold)(pwd | str replace $env.HOME "~")(ansi reset)(git_branch_name) (ansi red_bold)λ(ansi reset)\n(ansi attr_bold)$> "
}

$env.PROMPT_COMMAND = { prompt }
$env.PROMPT_INDICATOR = { "" }
