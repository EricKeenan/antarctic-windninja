# antarctic-windninja
Workflow to dynamically downscale wind speed and direction over Antarctica using the [WindNinja](https://github.com/firelab/windninja) model. 

## Example usage
This worfklow currently supports one spatial domain over Pine Island Glacier (PIG) in West Antarctica. 

First, edit job settings in `PIG/job.sbatch`. 

Then, execute dynamic downscalling with WindNinja: 
```bash
cd PIG
sbatch job.sbatch
```
