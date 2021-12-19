git submodule init
git submodule update
virtualenv env
# if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # ...
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  source env/bin/activate
#elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
#elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
#elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
#elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
#else
        # Unknown.
fi
pip install -r requirements.txt
