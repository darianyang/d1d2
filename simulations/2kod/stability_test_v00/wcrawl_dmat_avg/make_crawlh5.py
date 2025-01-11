import h5py
from shutil import copyfile

#crawl_aux = "tt_dist"
crawl_aux = "inter_ca_dmat"

# make new file to avoid corrupting main h5 file
#source_h5 = "west.h5"
#dest_h5 = "west_new.h5"
#copyfile(source_h5, dest_h5)

# goal is to copy over each iteration aux data from crawl to west
#west_h5 = h5py.File(dest_h5, mode="r+")
west_h5 = h5py.File("west.h5", mode="r+")
#crawl_h5 = h5py.File(f"{crawl_aux}.h5", mode="r")
#crawl_h5 = h5py.File(f"tt_dist9800-10000.h5", mode="r")
#crawl_h5 = h5py.File(f"inter_ca_dmat_1-8k.h5", mode="r")
crawl_h5 = h5py.File(f"inter_ca_dmat_8-13k.h5", mode="r")
# copies over all iterations available on the crawl h5 dataset
#for iter in range(5000, crawl_h5.attrs["iter_stop"]):
#for iter in range(1, 8001):
for iter in range(8090, 13389):
    print(iter)
    crawl_h5.copy(f"iterations/iter_{iter:08d}/{crawl_aux}",
                  west_h5[f"iterations/iter_{iter:08d}/auxdata"]
                  )
