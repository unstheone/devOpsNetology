# 1) Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea
## aefead2207ef7e2aa5dc81a34aedf0cad4c32545
    #git show aefea
    commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
          Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
          Date:   Thu Jun 18 10:29:58 2020 -0400
# 2) Какому тегу соответствует коммит 85024d3?
## v0.12.23
Пришлось сделать **git pull *URL* --tags**, т.к. ни в pycharm, ни в ubuntu не было тэгов и коммитов к ним относящихся. 
   После этого появилось:
          
     #git show 85024d3          
     commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)
     Author: tf-release-bot <terraform@hashicorp.com>
     Date:   Thu Mar 5 20:56:10 2020 +0000 
            v0.12.23
# 3) Сколько родителей у коммита b8d720? Напишите их хеши.
## 2 родителя, 56cd7859e 9ea88f22f
    #git show b8d720
    commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5
    Merge: 56cd7859e 9ea88f22f
# 4) Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.
    #git log --oneline --graph v0.12.23..v0.12.24 
	* 33ff1c03b (tag: v0.12.24) v0.12.24
	* b14b74c49 [Website] vmc provider links
	* 3f235065b Update CHANGELOG.md
	* 6ae64e247 registry: Fix panic when server is unreachable
	* 5c619ca1b website: Remove links to the getting started guide's old location
	* 06275647e Update CHANGELOG.md
	* d5f9411f5 command: Fix bug when using terraform login on Windows
	* 4b6d06cc5 Update CHANGELOG.md
	* dd01a3507 Update CHANGELOG.md
	* 225466bc3 Cleanup after v0.12.23 release
# 5) Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточия перечислены аргументы).
## 8c928e835 - в этом коммите
    #git log -S "func providerSource" --pretty=format:"%h, %an, %ad, %s"
	5af1e6234, Martin Atkins, Tue Apr 21 16:28:59 2020 -0700, main: Honor explicit provider_installation CLI config when present
	8c928e835, Martin Atkins, Thu Apr 2 18:04:39 2020 -0700, main: Consult local directories as potential mirrors of providers
# 6) Найдите все коммиты в которых была изменена функция globalPluginDirs.
## Сначала ищем файлы, в которых есть эта функция:
    #git grep "globalPluginDirs"
	commands.go:            GlobalPluginDirs: globalPluginDirs(),
	commands.go:    helperPlugins := pluginDiscovery.FindPlugins("credentials", globalPluginDirs())
	internal/command/cliconfig/config_unix.go:              // FIXME: homeDir gets called from globalPluginDirs during init, before
	plugins.go:// globalPluginDirs returns directories that should be searched for
	plugins.go:func globalPluginDirs() []string {
## Далее смотрим изменения по файлам, в которых встретилась искомая функция:
    #git log -L :globalPluginDirs:commands.go                 
	fatal: -L parameter 'globalPluginDirs' starting at line 1: no match
	#git log -L :globalPluginDirs:plugins.go                  
		commit 78b12205587fe839f10d946ea3fdc06719decb05
		Author: Pam Selle <204372+pselle@users.noreply.github.com>
		Date:   Mon Jan 13 16:50:05 2020 -0500

		commit 52dbf94834cb970b510f2fba853a5b49ad9b1a46
		Author: James Bardin <j.bardin@gmail.com>
		Date:   Wed Aug 9 17:46:49 2017 -0400

		commit 41ab0aef7a0fe030e84018973a64135b11abcd70
		Author: James Bardin <j.bardin@gmail.com>
		Date:   Wed Aug 9 10:34:11 2017 -0400

		commit 66ebff90cdfaa6938f26f908c7ebad8d547fea17
		Author: James Bardin <j.bardin@gmail.com>
		Date:   Wed May 3 22:24:51 2017 -0400

		commit 8364383c359a6b738a436d1b7745ccdce178df47
		Author: Martin Atkins <mart@degeneration.co.uk>
		Date:   Thu Apr 13 18:05:58 2017 -0700
# 7) Кто автор функции synchronizedWriters?
## Martin Arkins
    #git log -S 'synchronizedWriters' --pretty=format:"%h, %an, %ad, %s"
	bdfea50cc, James Bardin, Mon Nov 30 18:02:04 2020 -0500, remove unused
	fd4f7eb0b, James Bardin, Wed Oct 21 13:06:23 2020 -0400, remove prefixed io
	5ac311e2a, Martin Atkins, Wed May 3 16:25:41 2017 -0700, main: synchronize writes to VT100-faker on Windows