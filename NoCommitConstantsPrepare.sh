echo "Running NoCommitConstantsPrepare.sh"
echo "if it doesn't work, see NoCommitConstants-TEMPLATE.txt"

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
NAME="NoCommitConstants"
FILE_PATH="${SCRIPT_DIR}/${NAME}.swift"
TEMPLATE_FILE_PATH="${SCRIPT_DIR}/${NAME}-TEMPLATE.txt"

# copy but not replace
cp -n "${TEMPLATE_FILE_PATH}" "${FILE_PATH}"

if [[ -f "${FILE_PATH}" ]]; then
    echo "OK: ${FILE_PATH} exists"
    exit 0
else
    echo "Error: ${FILE_PATH} doesn't exist"
    exit 2
fi
