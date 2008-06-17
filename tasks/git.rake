namespace :git do
  def current_branch
    branches = `git branch`
    return branches.split("\n").detect {|x| x =~ /^\*/}.split(' ')[1]
  end

  desc "Push changes to central git repo"
  task :push do
    sh("git push origin master")
  end

  desc "update master branch"
  task :up do
    t_branch = current_branch
    sh("git checkout master")
    sh("git pull")
    sh("git checkout #{t_branch}")
  end

  desc "rebase current branch to master"
  task :rebase => [:up] do
    sh("git rebase master")
  end

  desc "merge current branch to master"
  task :merge => [:up] do
    t_branch = current_branch
    sh("git checkout master")
    sh("git merge #{t_branch}")
    sh("git checkout #{t_branch}")
  end

  desc "commot current branch"
  task :commit => [:merge] do
    t_branch = current_branch
    sh("git checkout master")
    sh("git push origin master")
    sh("git checkout #{t_branch}")
  end
end
