module.exports = (Impromptu, section) ->
  system = @module.require 'impromptu-system'
  git = @module.require 'impromptu-git'

  git.fetch()

  section 'bash:remind',
    content: 'Using Bash'
    when: /bash/i.test process.env.IMPROMPTU_SHELL
    foreground: 'yellow'

  section 'user',
    content: [system.user, system.shortHost]
    format: (user, host) ->
      return if user.trim() is process.env.DEFAULT_USER
      "#{user}@#{host}"
    background: 'black'
    foreground: 'white'

  section 'pwd',
    content: [system.prettyPwd, system.lastExitCode]
    background: 'blue'
    foreground: 'white'
    format: (pwd, code) ->
      @background = 'red' unless code is 0
      pwd

  section 'git:in',
    when: git.branch
    content: 'in'
    background: 'black'
    foreground: 'white'

  section 'git:branch',
    content: [git.branch, git.remoteBranch]
    background: 'green'
    foreground: 'black'
    format: (branch, remoteBranch) ->
      @background = 'white' unless remoteBranch
      branch

  section 'git:ahead',
    content: git.ahead
    background: 'black'
    foreground: 'green'
    when: git.isRepo
    format: (ahead) ->
      "#{ahead}⁺" if ahead

  section 'git:behind',
    content: git.behind
    background: 'black'
    foreground: 'red'
    when: git.isRepo
    format: (behind) ->
      "#{behind}⁻" if behind

  section 'git:staged',
    content: git.staged
    format: (staged) ->
      "staged #{staged}" if staged
    when: git.isRepo
    foreground: 'green'

  section 'git:unstaged',
    content: git.unstaged
    format: (unstaged) ->
      "unstaged #{unstaged}" if unstaged
    when: git.isRepo
    foreground: 'blue'

  section 'git:stashed',
    content: git.stashCount
    format: (count) ->
      "stashed #{count}"
    when: git.stashCount
    foreground: 'magenta'

  section 'end',
    content: '\n$'
    foreground: 'blue'
    options:
      newlines: true
