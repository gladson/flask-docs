Nilton -- Teste de DOC
=============================


It is very similar to Python's greenlet but built on top of the POSIX ``swapcontext()`` function. To take advantage of uGreen you have to set the number of async cores that will be mapped to green threads.

For example if you want to spawn 30 green threads:

.. code-block:: sh

  ./uwsgi -w tests.cpubound_green -s :3031 --async 30 --ugreen
  ls -ila

The ``ugreen`` option will enable uGreen on top of async mode.

Now when you call :py:func:`uwsgi.suspend` in your app, you'll be switched off to another green thread.

.. _green threads: http://en.wikipedia.org/wiki/Green_threads

Security and performance
------------------------

To ensure (relative) isolation of green threads, every stack area is protected by so called "guard pages".

An attempt to write out of the stack area of a green thread will result in a segmentation fault/bus error (and the process manager, if enabled, will respawn the worker without too much damage).

The context switch is very fast, we can see it as:

* On switch
  
  1. Save the Python Frame pointer
  2. Save the recursion depth of the Python environment (it is simply an int)
  3. Switch to the main stack

* On return

  1. Re-set the uGreen stack
  2. Re-set the recursion depth
  3. Re-set the frame pointer

The stack/registers switch is done by the POSIX ``swapcontext()`` call and we don't have to worry about it.


Can I use uGreen to write Comet apps?
-------------------------------------

Yeah! Sure! Go ahead. In the distribution you will find the ``ugreenchat.py`` script. It is a simple/dumb multiuser Comet chat. If you want to test it (for example 30 users) run it with

.. code-block:: sh

  ./uwsgi -s :3031 -w ugreenchat --async 30 --ugreen

The code has comments for every ugreen-related line. You'll need `Bottle`_, an amazing Python web micro framework to use it.

.. _Bottle: http://bottlepy.org/docs/dev/

