using Actors
import Actors: hear

struct HelloWorld end
struct Juli end
struct HelloWorld! end

function hear(s::Scene{A}, ::HelloWorld!) where {A}
    println("Hello, World! I am $(A)!")
    say(s, stage(s), Leave!())
end

hear(s::Scene{HelloWorld}, ::Genesis!) = say(s, enter!(s, Juli()), HelloWorld!())

play!(HelloWorld())


# using PyCall
# gym = pyimport("gym")
# env = gym.make('CartPole-v0')
# for i_episode in 1:20
#     observation = env.reset()
#     for t in 1:100
#         env.render()
#         print(observation)
#         action = env.action_space.sample()
#         observation, reward, done, info = env.step(action)
#         if done
#             print("Episode finished after {} timesteps".format(t+1))
#             break
#         end
#     end
# end
# env.close()


# TestApp().run()

# arch: sudo pacman -U https://archive.archlinux.org/packages/b/binutils/binutils-2.30-5-x86_64.pkg.tar.xz
# py"""
# import subprocess
# import sys
# subprocess.check_call([sys.executable, "-m", "pip", "install", "Kivy==2.0.0rc1"])
# """
# using Conda
#
# Conda.add("cython")
#
# cd(".../core")
#
# py"""
# from distutils.core import run_setup
# run_setup("setup.py", script_args=["build_ext", "install"],stop_after="run")
# """
# refresh
#
# install cymunk
#
# pyimport("cymunk")
#
# /Users/ngraff507/Downloads/kivent/modules/cymunk (maps)
#
# install tmx
#
# /Users/ngraff507/Downloads/kivent/modules/core/
