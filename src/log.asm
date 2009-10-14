
            .include "log.inc"

            .segment "LOGMSG_MSGS"

LOGMSG_INITIALIZED:
            .byte "Initialization complete"

LOGMSG_IP_DOWN:
            .byte "IP layer is down"

LOGMSG_IP_UP:
            .byte "IP layer is up"

LOGMSG_MAC_DOWN:
            .byte "MAC layer is down"

LOGMSG_MAC_UP:
            .byte "MAC layer is up"

LOGMSG_PHY_DOWN:
            .byte "PHY layer is down"

LOGMSG_PHY_UP:
            .byte "PHY layer is up"

LOGMSG_AUTONEG_FAILED:
            .byte "Auto-negotiation failed"

LOGMSG_AUTONEG_SUCCEEDED:
            .byte "Auto-negotiation succeeded"

LOGMSG_LINK_UP:
            .byte "Link is up"

LOGMSG_HALF:
            .byte "Half duplex"

LOGMSG_FULL:
            .byte "Full duplex"

