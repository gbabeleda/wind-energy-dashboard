import pandas as pd
import os
import inspect

def dataframe_to_local(dataframe: pd.DataFrame, output_folder: str = "", output_name: str = None) -> None:
    # Use the variable name of the dataframe as the default output name
    if output_name is None:
        for var_name, var_val in inspect.currentframe().f_back.f_locals.items():
            if var_val is dataframe:
                output_name = var_name
                break
        if output_name is None:
            raise ValueError("Could not determine the output_name automatically. Please provide an output_name.")

    if output_folder == "":
        raise ValueError("Please provide an output_folder")

    if not output_name.endswith(".csv"):
        output_name += ".csv"

    # Create the folder if it doesn't exist
    os.makedirs(output_folder, exist_ok=True)

    csv_path = os.path.join(output_folder, output_name)

    # Check if file already exists
    if os.path.exists(csv_path):
        overwrite = input(f"The file '{output_name}' already exists in '{output_folder}'. Overwrite? (y/n): ").strip().lower()
        if overwrite != 'y':
            print("Operation cancelled.")
            return

    dataframe.to_csv(csv_path, index=False)

    print(f"Dataframe saved as '{output_name}' in the local folder '{output_folder}'")
