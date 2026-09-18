#!/bin/bash

##############################################################################
# PVT Corner Characterization Loop for mx_delay_2BL.tcl
# Uses the 8 corners defined in AGENTS.md.
# Usage: ./run_pvt_characterization_2BL.sh
##############################################################################

set -euo pipefail

WORKSPACE_DIR="/project/atlas/gdp/workspaces/hwangh_atlas_A0_dev/Liberate_flow"
TCL_TEMPLATE="${WORKSPACE_DIR}/tcl/mx_constraint_backup_2BL.tcl"
TCL_DIR="${WORKSPACE_DIR}/tcl/generated"
WRAPPER_DIR="${WORKSPACE_DIR}/wrappers_2BL"
LOG_DIR="${WORKSPACE_DIR}/logs"

mkdir -p "${TCL_DIR}"
mkdir -p "${WRAPPER_DIR}"
mkdir -p "${LOG_DIR}"

# 8 corners from AGENTS.md
# Format: "VOLTS:TEMP:MODEL:DSPF:LIBNAME:LOGNAME"
declare -a PVT_CORNERS=(
    "0.72:-40:include_models_ss:FuncRCmaxDP:gcram3tdp707n512x532m1sb_constupdate_ssm40_RCmax.lib:ssm40_rcmax_detailed_constupdate.log"
    "0.72:-40:include_models_ss:FuncRCminDP:gcram3tdp707n512x532m1sb_constupdate_ssm40_RCmin.lib:ssm40_rcmin_detailed_constupdate.log"
    "0.72:125:include_models_ss:FuncRCmaxDP:gcram3tdp707n512x532m1sb_constupdate_ssm125_RCmax.lib:ss125_rcmax_detailed_constupdate.log"
    "0.72:125:include_models_ss:FuncRCminDP:gcram3tdp707n512x532m1sb_constupdate_ssm125_RCmin.lib:ss125_rcmin_detailed_constupdate.log"
    "0.88:-40:include_models_ff:FuncRCmaxDP:gcram3tdp707n512x532m1sb_constupdate_ffm40_RCmax.lib:ffm40_rcmax_detailed_constupdate.log"
    "0.88:-40:include_models_ff:FuncRCminDP:gcram3tdp707n512x532m1sb_constupdate_ffm40_RCmin.lib:ffm40_rcmin_detailed_constupdate.log"
    "0.88:125:include_models_ff:FuncRCmaxDP:gcram3tdp707n512x532m1sb_constupdate_ffm125_RCmax.lib:ff125_rcmax_detailed_constupdate.log"
    "0.88:125:include_models_ff:FuncRCminDP:gcram3tdp707n512x532m1sb_constupdate_ffm125_RCmin.lib:ff125_rcmin_detailed_constupdates.log"
)

echo "=========================================="
echo "2BL PVT Corner Characterization Loop"
echo "Total corners to process: ${#PVT_CORNERS[@]}"
echo "=========================================="
echo ""

for idx in "${!PVT_CORNERS[@]}"; do
    corner="${PVT_CORNERS[$idx]}"
    VOLTS=$(echo "$corner" | cut -d: -f1)
    TEMP=$(echo "$corner" | cut -d: -f2)
    MODEL=$(echo "$corner" | cut -d: -f3)
    DSPF=$(echo "$corner" | cut -d: -f4)
    LIBNAME=$(echo "$corner" | cut -d: -f5)
    LOGNAME=$(echo "$corner" | cut -d: -f6)
    TRIG_VAL=$(awk "BEGIN {printf \"%.3f\", ${VOLTS} * 0.1}")
    export TRIG_VAL

    CORNER_ID=$(printf "%02d" $((idx + 1)))
    CORNER_TAG="${VOLTS}V_${TEMP}C"
    TCL_FILE="${TCL_DIR}/mx_constpartial2bl_${CORNER_ID}_${CORNER_TAG}.tcl"
#    RAIL_VDD_FILE="${TCL_DIR}/rail_vdd_${CORNER_ID}_${CORNER_TAG}.tcl"
    WRAPPER_FILE="${WRAPPER_DIR}/submit_2BL_${CORNER_ID}_${CORNER_TAG}.sh"
    LOG_FILE="${LOG_DIR}/${LOGNAME}"

    echo "[${CORNER_ID}/8] Preparing corner: ${CORNER_TAG}"
    echo "  Volts: ${VOLTS}V, Temp: ${TEMP}C, Model: ${MODEL}, DSPF: ${DSPF}"
    # echo "  trig_val (10% VDD): ${TRIG_VAL}"
    # echo "  targ_val (10% VDD): ${TRIG_VAL}"
    echo "  TCL: ${TCL_FILE}"
    echo "  Log: ${LOG_FILE}"


    # perl -pi -e 's|^(\s*-trig_val\s+)\S+|$1$ENV{TRIG_VAL}|' "${WORKSPACE_DIR}/tcl/generated_arcs.tcl"
    # perl -pi -e 's|^(\s*-targ_val\s+)\S+|$1$ENV{TRIG_VAL}|' "${WORKSPACE_DIR}/tcl/generated_arcs.tcl"

    cp "${TCL_TEMPLATE}" "${TCL_FILE}"
#    cp "${WORKSPACE_DIR}/tcl/rail_vdd.tcl" "${RAIL_VDD_FILE}"
#    perl -pi -e 's/\b0\.72\b/'"${VOLTS}"'/g' "${RAIL_VDD_FILE}"
# 1. Update Voltage Variables and Operating Conditions
# 1. Update Voltages and Operating Conditions
    perl -pi -e 's|^set VDD \S+|set VDD '"${VOLTS}"'|' "${TCL_FILE}"
    perl -pi -e 's|^set_vdd VDD \S+|set_vdd VDD '"${VOLTS}"'|' "${TCL_FILE}"
    perl -pi -e 's|^set_operating_condition .*|set_operating_condition -voltage \$VDD -temp '"${TEMP}"'|' "${TCL_FILE}"

    # 2. Update Simulation Models (Both the set_var and the read_spice lines)
    perl -pi -e 's|^set_var extsim_model_include .*|set_var extsim_model_include \${datadir}/'"${MODEL}"'|' "${TCL_FILE}"
    perl -pi -e 's|^read_spice -format spectre -parser sfe \$\{datadir\}/include_models_ss.*|read_spice -format spectre -parser sfe \${datadir}/'"${MODEL}"'|' "${TCL_FILE}"

    # 3. Update DSPF Netlist and Output Library Filename
    perl -pi -e 's|^read_spice -format spice .*|read_spice -format spice \${datadir}/gcram3tdp707n512x532m1sb_v4_RCC_'"${DSPF}"'_25C.dspf|' "${TCL_FILE}"
    perl -pi -e 's|^write_library .*|write_library -overwrite -filename \${outdir}/LIBS_DBL_FINAL/'"${LIBNAME}"' gcram3tdp707n512x532m1sb|' "${TCL_FILE}"
#    perl -pi -e 's|^source ./tcl/rail_vdd\.tcl|source '"${RAIL_VDD_FILE}"'|' "${TCL_FILE}"


    cat > "${WRAPPER_FILE}" <<WRAPPER_EOF
#!/bin/bash
module load LIBERATE
module unload SPECTRE
cd ${WORKSPACE_DIR}
liberate_mx --trio ${TCL_FILE} |& tee ${LOG_FILE}
WRAPPER_EOF

    chmod +x "${WRAPPER_FILE}"
    echo "  ✓ Wrapper created"

    echo "  → Submitting job for corner ${CORNER_TAG}"
    JOB_OUTPUT=$(submitjob --outlikesge -n 64 -m 256 "${WRAPPER_FILE}" 2>&1)
    JOB_ID=$(printf '%s\n' "$JOB_OUTPUT" | grep -oE 'Your job [0-9]+' | awk '{print $3}' | head -1 || true)
    if [ -z "${JOB_ID}" ]; then
        JOB_ID=$(printf '%s\n' "$JOB_OUTPUT" | grep -oE '^[0-9]+' | head -1 || true)
    fi

    if [ -z "${JOB_ID}" ]; then
        echo "  ✗ Could not detect job ID from submitjob output"
        echo "  Output: ${JOB_OUTPUT}"
        exit 1
    fi

    echo "  ✓ Job submitted with ID: ${JOB_ID}"
    echo "  ⏳ Waiting for ${JOB_ID} to complete..."

    while true; do
        JOB_STATUS=$(qstat "${JOB_ID}" 2>&1 || true)
        if echo "${JOB_STATUS}" | grep -q -E 'Unknown job ID|not found|does not exist|Job has finished|finished'; then
            echo "  ✓ Job ${JOB_ID} completed successfully."
            break
        fi
        sleep 30
    done

    echo "  → Cleaning temporary directories"
    rm -rf "${WORKSPACE_DIR}/tmp_dir"
    rm -rf "${WORKSPACE_DIR}/decks"
    rm -rf "${WORKSPACE_DIR}/mx"

# Check if the tmp_dir directory exists, then rename it uniquely per corner
    # if [ -d "${WORKSPACE_DIR}/tmp_dir" ]; then
    #     echo "  → Renaming 'tmp_dir' folder to 'tmp_dir_${CORNER_ID}_${CORNER_TAG}'"
    #     mv "${WORKSPACE_DIR}/tmp_dir" "${WORKSPACE_DIR}/tmp_dir_${CORNER_ID}_${CORNER_TAG}"
    # else
    #     echo "  ⚠️ 'tmp_dir' directory not found, skipping rename."
    # fi

    rm -rf "${WORKSPACE_DIR}/LDB"
    rm -rf "${WORKSPACE_DIR}/gcram3tdp707n512x532m1sb_constraints_partial_0_sim.ahdlSimDB"
    rm -rf "${WORKSPACE_DIR}/gcram3tdp707n512x532m1sb_constraints_partial_auto_hold_1_sim.ahdlSimDB"
    echo "  ✓ Cleanup done"
    echo ""
done

echo "=========================================="
echo "All 8 corners completed sequentially"
echo "Logs are in: ${LOG_DIR}"
echo "=========================================="
