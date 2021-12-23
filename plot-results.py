import argparse
import urllib.parse as url
from io import BytesIO

import google.cloud.storage as gs
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# conda+mamba - shades of green (Derived from anaconda website)
# poetry - shades of blue  (Derived from their logo)
# pip,venv - shades of yellow (Python native tool)
# pip-tools - shades of red (Jazz Band)
# pyenv - orange (A color distinct from the others, but most related to Python native stuff)
# pipenv - shades of violet (A color distinct from the others)

# anaconda_green = '#89cb6f'
# mamba_black = '#1c1c19'
# poetry_blues = ['#5062cc', '#398cd7', '#52bcea']
# pipenv
# jazz_band_reds = ['#8b3520', '#d77058']
# python_blue = '#235789'
# python_yellow = '#f1d302'

colors = {
    'conda': '#89cb6f',
    'conda-lock': '#c6e6ba',
    'conda+pip': '#99ad8d',
    'mamba': '#3c6524',
    'mamba-lock': '#4e822f',
    'mamba+pip': '#434b3e',
    'pip-compile': '#8b3520',
    'pip-lock': '#d77058',
    'pip-wheel-lock': '#ebb7ab',
    'pip+pyenv': '#f19702',
    'pip+venv': '#f1d302',
    'pipenv': '#9370db',
    'pipenv-lock': '#b79fe7',
    'pipenv-skip-lock': '#c970db',
    'poetry': '#5062cc',
    'poetry-lock': '#398cd7'
}


def plot(project, df, image_file, python_version, show_image=False):
    sorted_indices = df.groupby('env').median().sort_values('time').index
    sorted_colors = [colors[i] for i in sorted_indices]
    sns_plot = sns.barplot(x='env',
                           y='time',
                           data=df,
                           order=sorted_indices,
                           palette=sorted_colors)
    ax = plt.gca()
    ax.set_ylabel('Time (s)')
    ax.set_xlabel('Environment Resolver')
    _ = plt.xticks(rotation=15)
    ax.set_title(
        f'{project.capitalize()} Environment Resolution Time (Python {python_version})'
    )
    if show_image:
        plt.show()
    fig = sns_plot.figure
    fig.set_size_inches(1800 / fig.dpi, 900 / fig.dpi)
    fig.savefig(image_file)


def process_results_file(results_file_uri):
    parse_results = url.urlparse(results_file_uri)
    if 'gs' == parse_results.scheme:
        client = gs.Client()
        bucket = client.get_bucket(parse_results.netloc)
        blob_name = parse_results.path.lstrip('/')
        return pd.read_csv(
            BytesIO(bucket.get_blob(blob_name).download_as_string()))
    else:
        return pd.read_csv(results_file_uri)


def main():
    parser = argparse.ArgumentParser(
        description=
        'Plot Python environment manager profiling results from input text file. '
        'File can be local or object in Google storage bucket with URI starting with "gs://". '
        'File must be formatted as CSV file with header \"env,time\". '
        'Plot will be saved to an output image file.')
    parser.add_argument('-p',
                        '--project',
                        type=str,
                        default=False,
                        required=True,
                        help='Project name.')
    parser.add_argument('-f',
                        '--results-file',
                        type=str,
                        default=False,
                        required=True,
                        help='Path to the input results file.')
    parser.add_argument('-i',
                        '--image-file',
                        type=str,
                        default=False,
                        required=True,
                        help='Path to the output image file.')
    parser.add_argument('-s',
                        '--show',
                        action='store_true',
                        help='Show image onscreen before saving.')
    parser.add_argument(
        '-v',
        '--python-version',
        default=False,
        required=True,
        help='Python version used for profiling. Example: --python-version=3.7'
    )
    parser.set_defaults(show=False)
    args = parser.parse_args()
    results_df = process_results_file(args.results_file)
    plot(args.project, results_df, args.image_file, args.python_version,
         args.show)


if '__main__' == __name__:
    main()
