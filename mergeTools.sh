

#check pramaters
if [ $# -lt 1 ]; then
echo "please input your branch."
exit
fi
branch=$1
merBranch="develop"
if [ "$2" != "" ]; then
merBranch=$2
fi

#check branch
if [ `git branch -a | grep $branch$ | wc -l` -eq 0 ];then
echo "the $branch is not existed"
exit
fi

#merge
git checkout $merBranch
echo "the current branch is "`git branch | grep \* | cut -d " " -f 2`
git pull --rebase origin $merBranch

git checkout $branch
echo "the current branch is "`git branch | grep \* | cut -d " " -f 2`
log=`git merge $merBranch | grep conflict`

if [ "$log" != "" ];then
echo 'conflit occurred'
git merge --abort
exit
fi
echo "merge successfully"
