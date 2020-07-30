All: PerfectHash

PerfectHash: Perfecthash/Makefile

Perfecthash/Makefile:
	cd PerfectHash && ./configure && make && ./neigh2d

clean:
	cd PerfectHash; make clean; make distclean
