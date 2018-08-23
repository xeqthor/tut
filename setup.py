
from setuptools import setup

__VERSION__ = '0.2.5'

if __name__ == "__main__":
    setup(
        name='fin2018',
        version=__VERSION__,
        package_dir={'': 'src'},
        entry_points={
            'console_scripts': [
            ]
        },
    )
