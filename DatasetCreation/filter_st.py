import os
import shutil

# ==========================================
# 1. DATA (Target File Lists)
# ==========================================

BASIC_TARGETS = [
    # Sequencers & State Machines
    "SEQUENCE_4.ST", "SEQUENCE_8.ST", "SEQUENCE_64.ST", "EVENTS.ST",
    "SCHEDULER.ST", "SCHEDULER_2.ST", "CYCLE_4.ST", "STAIR.ST", "STAIR2.ST",
    # Controllers & Feedback Loops
    "CTRL_PID.ST", "CTRL_PI.ST", "CTRL_PWM.ST", "CTRL_IN.ST", "CTRL_OUT.ST",
    "FLOW_CONTROL.ST", "FLOW_CONTROL_4.ST", "TUNE.ST", "TUNE2.ST",
    # Safety, Alarms & Interlocks
    "ALARM_2.ST", "INTERLOCK.ST", "INTERLOCK_4.ST", "CALIBRATE.ST", "TIMECHECK.ST",
    # Hardware Drivers & Interfaces
    "DRIVER_1.ST", "DRIVER_4.ST", "DRIVER_4C.ST", "SENSOR_INT.ST",
    "AIN.ST", "AIN1.ST", "AOUT.ST", "AOUT1.ST",
    # Manual Overrides & Selectors
    "MANUAL.ST", "MANUAL_1.ST", "MANUAL_2.ST", "MANUAL_4.ST",
    "CONTROL_SET1.ST", "CONTROL_SET2.ST",
    # Stateful Signal Processing & Metering
    "HYST.ST", "HYST_1.ST", "HYST_2.ST", "HYST_3.ST",
    "GEN_PULSE.ST", "GEN_SQ.ST", "GEN_RMP.ST", "FADE.ST",
    "METER.ST", "METER_STAT.ST", "FLOW_METER.ST", "ENERGY.ST", "ONTIME.ST",
    "CLICK_CNT.ST", "CLICK_DEC.ST", "LTCH.ST", "LTCH_4.ST",
    # Timers, Delays & Clocks
    "TONOF.ST", "TOF_1.ST", "TP_X.ST", "TP_1.ST", "TP_1D.ST", 
    "DELAY.ST", "DELAY_4.ST", "CLK_DIV.ST", "CLK_N.ST", "CLK_PRG.ST", "CLK_PULSE.ST", "TICKER.ST",
    # Flip-Flops & Triggers
    "FF_DRE.ST", "FF_D2E.ST", "FF_D4E.ST", "FF_JKE.ST", "FF_RSE.ST", 
    "A_TRIG.ST", "B_TRIG.ST", "D_TRIG.ST",
    # Counters & Steppers
    "COUNT_BR.ST", "COUNT_DR.ST", "INC.ST", "INC1.ST", "INC2.ST", "INC_DEC.ST", 
    "DEC1.ST", "DEC_2.ST", "DEC_4.ST", "DEC_8.ST",
    # Ramps & PWM
    "RMP_B.ST", "RMP_W.ST", "RMP_SOFT.ST", "FRMP_B.ST", "SRAMP.ST", 
    "PWM_DC.ST", "PWM_PW.ST",
    # Advanced Filters & Integrators
    "FT_AVG.ST", "FT_DERIV.ST", "FT_IMP.ST", "FT_INT.ST", "FT_INT2.ST", "FT_MIN_MAX.ST", 
    "FT_PD.ST", "FT_PDT1.ST", "FT_PI.ST", "FT_PID.ST", "FT_PIDW.ST", "FT_PIDWL.ST", 
    "FT_PIW.ST", "FT_PIWL.ST", "FT_PROFILE.ST", "FT_PT1.ST", "FT_PT2.ST", "FT_RMP.ST",
    # Memory Buffers & Event Trackers
    "FIFO_16.ST", "FIFO_32.ST", "STACK_16.ST", "STACK_32.ST",
    "ESR_COLLECT.ST", "ESR_MON_B8.ST", "ESR_MON_R4.ST", "ESR_MON_X8.ST",
    "MESSAGE_8.ST", "MESSAGE_4R.ST"
]

NETWORK_TARGETS = [
    # Clients & Servers
    "FTP_CLIENT.ST", "HTTP_GET.ST", "SMTP_CLIENT.ST", "DNS_CLIENT.ST", 
    "DNS_REV_CLIENT.ST", "SNTP_CLIENT.ST", "SNTP_SERVER.ST", 
    "MB_CLIENT.ST", "MB_SERVER.ST", "FILE_SERVER.ST", "IP_CONTROL.ST", "IP_CONTROL2.ST",
    # Web APIs
    "YAHOO_WEATHER.ST", "WORLD_WEATHER.ST", "IP2GEO.ST", "SPIDER_ACCESS.ST",
    # Data Loggers
    "DLOG_STORE_FILE_CSV.ST", "DLOG_STORE_FILE_HTML.ST", "DLOG_STORE_FILE_XML.ST", 
    "DLOG_STORE_RRD.ST", "DLOG_FILE_TO_FTP.ST", "DLOG_FILE_TO_SMTP.ST", "FILE_BLOCK.ST",
    # Telnet UI
    "TN_FRAMEWORK.ST", "TN_RECEIVE.ST", "TN_INPUT_CONTROL.ST", 
    "TN_INPUT_MENU_BAR.ST", "TN_INPUT_EDIT_LINE.ST", "LOG_VIEWPORT.ST"
]

BUILDING_TARGETS = [
    # Blind & Shutter State Machines
    "BLIND_ACTUATOR.ST", "BLIND_CONTROL.ST", "BLIND_CONTROL_S.ST", 
    "BLIND_INPUT.ST", "BLIND_NIGHT.ST", "BLIND_SCENE.ST", 
    "BLIND_SECURITY.ST", "BLIND_SET.ST", "BLIND_SHADE.ST", "BLIND_SHADE_S.ST",
    
    # HVAC, Actuators & Plant Control
    "ACTUATOR_2P.ST", "ACTUATOR_3P.ST", "ACTUATOR_A.ST", 
    "ACTUATOR_COIL.ST", "ACTUATOR_PUMP.ST", "ACTUATOR_UD.ST", 
    "BOILER.ST", "BURNER.ST", "F_LAMP.ST", "LEGIONELLA.ST",
    
    # Lighting, Dimmers & Human Interfaces
    "CLICK.ST", "CLICK_MODE.ST", "DEBOUNCE.ST", 
    "DIMM_2.ST", "DIMM_I.ST", "SWITCH_I.ST", "SWITCH_X.ST", "SW_RECONFIG.ST",
    
    # Timers, Schedulers & Long-Term Memory
    "AUTORUN.ST", "PULSE_LENGTH.ST", "PULSE_T.ST", 
    "TIMER_1.ST", "TIMER_2.ST", "TIMER_EVENT_DECODE.ST", 
    "TIMER_EXT.ST", "TIMER_P4.ST", "HEAT_METER.ST", "T_AVG24.ST"
]

# ==========================================
# 2. LOGIC (Reusable Functions)
# ==========================================

def extract_files(source_dir: str, dest_dir: str, file_list: list) -> tuple:
    """
    Copies a specific list of files from source to destination.
    Returns a tuple of (number_copied, list_of_missing_files).
    """
    if not os.path.exists(dest_dir):
        os.makedirs(dest_dir)

    copied_count = 0
    missing_files = []

    for filename in file_list:
        src_path = os.path.join(source_dir, filename)
        dest_path = os.path.join(dest_dir, filename)
        
        if os.path.exists(src_path):
            shutil.copy2(src_path, dest_path)
            copied_count += 1
        else:
            missing_files.append(filename)
            
    return copied_count, missing_files


def print_report(batch_name: str, copied: int, missing: list):
    """Prints a clean, readable summary to the console."""
    print(f"\n[{batch_name} Summary]")
    print(f"✅ Successfully copied: {copied} files")
    
    if missing:
        print(f"❌ Missing ({len(missing)} files):")
        for f in missing:
            print(f"   - {f}")


# ==========================================
# 3. EXECUTION
# ==========================================

def main():
    print("Starting Extraction Pipeline...")

    # If there is need to re-run Batch 1, just uncomment these two lines
    # c1, m1 = extract_files("module_export_BASIC", "batch1_filtered_BASIC", BASIC_TARGETS)
    # print_report("BATCH 1 (Basic)", c1, m1)

    # Run Batch 2 (Network)
    # c2, m2 = extract_files("module_export_NETWORK", "batch2_filtered_NETWORK", NETWORK_TARGETS)
    # print_report("BATCH 2 (Network)", c2, m2)

    # Run Batch 3 (Building)
    c3, m3 = extract_files("module_export_BUILDING", "batch2_filtered_BUILDING", BUILDING_TARGETS)
    print_report("BATCH 3 (Building)", c3, m3)

if __name__ == "__main__":
    main()