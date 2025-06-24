#!/bin/bash

# Customer Service Agent - Ansible Deployment Script
# Automation Engineer Portfolio - Comprehensive Deployment Automation
# Demonstrates: Multi-environment deployment, cost optimization, monitoring

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ANSIBLE_DIR="$PROJECT_ROOT/ansible"
LOG_DIR="$PROJECT_ROOT/logs"
BACKUP_DIR="$PROJECT_ROOT/backups"

# Default values
ENVIRONMENT="development"
DEPLOYMENT_VERSION="latest"
TARGET_HOSTS=""
DRY_RUN=false
VERBOSE=false
SKIP_BACKUP=false
SKIP_MONITORING=false
NOTIFICATION_WEBHOOK=""

# Cost optimization settings
COST_OPTIMIZATION=true
RESOURCE_LIMITS=true
AUTO_SCALING=true

# Performance settings
PARALLEL_JOBS=5
TIMEOUT=300
RETRY_ATTEMPTS=3

# Logging
LOG_FILE="$LOG_DIR/ansible-deploy-$(date +%Y%m%d-%H%M%S).log"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

# Function to display usage
usage() {
    cat << EOF
Customer Service Agent - Ansible Deployment Script
Automation Engineer Portfolio - Comprehensive Deployment Automation

Usage: $0 [OPTIONS] COMMAND

Commands:
    deploy          Deploy the application to specified environment
    update          Perform rolling update deployment
    monitor         Setup monitoring and observability
    backup          Create backup before deployment
    rollback        Rollback to previous version
    health-check    Perform comprehensive health check
    cost-optimize   Apply cost optimization settings

Options:
    -e, --environment ENV     Target environment (development|staging|production)
    -v, --version VERSION     Deployment version (default: latest)
    -h, --hosts HOSTS         Target hosts (default: all)
    -d, --dry-run            Perform dry run without actual changes
    -V, --verbose            Enable verbose output
    -s, --skip-backup        Skip backup before deployment
    -m, --skip-monitoring    Skip monitoring setup
    -w, --webhook URL        Notification webhook URL
    -c, --cost-optimize      Enable cost optimization (default: true)
    -r, --resource-limits    Enable resource limits (default: true)
    -a, --auto-scaling       Enable auto-scaling (default: true)
    -p, --parallel JOBS      Number of parallel jobs (default: 5)
    -t, --timeout SECONDS    Operation timeout (default: 300)
    --help                   Display this help message

Examples:
    # Deploy to development environment
    $0 deploy -e development

    # Rolling update to production
    $0 update -e production -v v1.2.0

    # Setup monitoring for all environments
    $0 monitor -e all

    # Cost-optimized deployment
    $0 deploy -e staging -c -r -a

    # Dry run deployment
    $0 deploy -e production -d -V

EOF
}

# Function to validate prerequisites
validate_prerequisites() {
    print_status "Validating deployment prerequisites..."

    # Check if Ansible is installed
    if ! command -v ansible &> /dev/null; then
        print_error "Ansible is not installed. Please install Ansible first."
        exit 1
    fi

    # Check if Ansible version is compatible
    ANSIBLE_VERSION=$(ansible --version | head -n1 | awk '{print $2}')
    print_status "Ansible version: $ANSIBLE_VERSION"

    # Check if inventory file exists
    if [[ ! -f "$ANSIBLE_DIR/inventory/hosts.yml" ]]; then
        print_error "Inventory file not found: $ANSIBLE_DIR/inventory/hosts.yml"
        exit 1
    fi

    # Check if playbooks exist
    if [[ ! -f "$ANSIBLE_DIR/playbooks/main.yml" ]]; then
        print_error "Main playbook not found: $ANSIBLE_DIR/playbooks/main.yml"
        exit 1
    fi

    # Create necessary directories
    mkdir -p "$LOG_DIR" "$BACKUP_DIR"

    print_success "Prerequisites validation completed"
}

# Function to setup environment variables
setup_environment() {
    print_status "Setting up environment variables..."

    # Load environment-specific variables
    if [[ -f "$PROJECT_ROOT/.env.$ENVIRONMENT" ]]; then
        source "$PROJECT_ROOT/.env.$ENVIRONMENT"
        print_status "Loaded environment variables from .env.$ENVIRONMENT"
    fi

    # Set default values if not provided
    export GOOGLE_API_KEY_DEV="${GOOGLE_API_KEY_DEV:-}"
    export GOOGLE_API_KEY_STAGING="${GOOGLE_API_KEY_STAGING:-}"
    export GOOGLE_API_KEY_PROD="${GOOGLE_API_KEY_PROD:-}"

    # Validate required variables
    case "$ENVIRONMENT" in
        "development")
            if [[ -z "$GOOGLE_API_KEY_DEV" ]]; then
                print_warning "GOOGLE_API_KEY_DEV not set"
            fi
            ;;
        "staging")
            if [[ -z "$GOOGLE_API_KEY_STAGING" ]]; then
                print_warning "GOOGLE_API_KEY_STAGING not set"
            fi
            ;;
        "production")
            if [[ -z "$GOOGLE_API_KEY_PROD" ]]; then
                print_error "GOOGLE_API_KEY_PROD is required for production deployment"
                exit 1
            fi
            ;;
    esac

    print_success "Environment setup completed"
}

# Function to create backup
create_backup() {
    if [[ "$SKIP_BACKUP" == true ]]; then
        print_warning "Skipping backup as requested"
        return 0
    fi

    print_status "Creating backup before deployment..."

    BACKUP_FILE="$BACKUP_DIR/backup-$(date +%Y%m%d-%H%M%S).tar.gz"
    
    # Create backup of current deployment
    cd "$ANSIBLE_DIR"
    ansible-playbook \
        --inventory inventory/hosts.yml \
        --limit "$TARGET_HOSTS" \
        --extra-vars "backup_file=$BACKUP_FILE" \
        playbooks/backup.yml \
        --check="$DRY_RUN" \
        --verbose="$VERBOSE" \
        --timeout="$TIMEOUT" \
        --forks="$PARALLEL_JOBS" \
        >> "$LOG_FILE" 2>&1

    if [[ $? -eq 0 ]]; then
        print_success "Backup created: $BACKUP_FILE"
    else
        print_error "Backup creation failed"
        exit 1
    fi
}

# Function to deploy application
deploy_application() {
    print_status "Deploying Customer Service Agent to $ENVIRONMENT environment..."

    # Build extra vars
    EXTRA_VARS="deployment_environment=$ENVIRONMENT"
    
    if [[ "$DEPLOYMENT_VERSION" != "latest" ]]; then
        EXTRA_VARS="$EXTRA_VARS,deployment_version=$DEPLOYMENT_VERSION"
    fi
    
    if [[ -n "$NOTIFICATION_WEBHOOK" ]]; then
        EXTRA_VARS="$EXTRA_VARS,notification_webhook=$NOTIFICATION_WEBHOOK"
    fi
    
    if [[ "$COST_OPTIMIZATION" == true ]]; then
        EXTRA_VARS="$EXTRA_VARS,cost_optimization=true"
    fi
    
    if [[ "$RESOURCE_LIMITS" == true ]]; then
        EXTRA_VARS="$EXTRA_VARS,resource_limits=true"
    fi
    
    if [[ "$AUTO_SCALING" == true ]]; then
        EXTRA_VARS="$EXTRA_VARS,auto_scaling=true"
    fi

    # Run deployment playbook
    cd "$ANSIBLE_DIR"
    ansible-playbook \
        --inventory inventory/hosts.yml \
        --limit "$TARGET_HOSTS" \
        --extra-vars "$EXTRA_VARS" \
        playbooks/main.yml \
        --check="$DRY_RUN" \
        --verbose="$VERBOSE" \
        --timeout="$TIMEOUT" \
        --forks="$PARALLEL_JOBS" \
        --retry-files-enabled \
        --retry-files-save-path="$LOG_DIR" \
        >> "$LOG_FILE" 2>&1

    if [[ $? -eq 0 ]]; then
        print_success "Deployment completed successfully"
    else
        print_error "Deployment failed. Check logs: $LOG_FILE"
        exit 1
    fi
}

# Function to perform rolling update
rolling_update() {
    print_status "Performing rolling update to $ENVIRONMENT environment..."

    EXTRA_VARS="target_environment=$ENVIRONMENT,deployment_version=$DEPLOYMENT_VERSION"
    
    if [[ -n "$NOTIFICATION_WEBHOOK" ]]; then
        EXTRA_VARS="$EXTRA_VARS,notification_webhook=$NOTIFICATION_WEBHOOK"
    fi

    cd "$ANSIBLE_DIR"
    ansible-playbook \
        --inventory inventory/hosts.yml \
        --limit "$TARGET_HOSTS" \
        --extra-vars "$EXTRA_VARS" \
        playbooks/rolling-update.yml \
        --check="$DRY_RUN" \
        --verbose="$VERBOSE" \
        --timeout="$TIMEOUT" \
        --forks=1 \
        --serial=1 \
        >> "$LOG_FILE" 2>&1

    if [[ $? -eq 0 ]]; then
        print_success "Rolling update completed successfully"
    else
        print_error "Rolling update failed. Check logs: $LOG_FILE"
        exit 1
    fi
}

# Function to setup monitoring
setup_monitoring() {
    if [[ "$SKIP_MONITORING" == true ]]; then
        print_warning "Skipping monitoring setup as requested"
        return 0
    fi

    print_status "Setting up monitoring and observability..."

    EXTRA_VARS="target_hosts=$TARGET_HOSTS"

    cd "$ANSIBLE_DIR"
    ansible-playbook \
        --inventory inventory/hosts.yml \
        --limit "$TARGET_HOSTS" \
        --extra-vars "$EXTRA_VARS" \
        playbooks/monitoring.yml \
        --check="$DRY_RUN" \
        --verbose="$VERBOSE" \
        --timeout="$TIMEOUT" \
        --forks="$PARALLEL_JOBS" \
        >> "$LOG_FILE" 2>&1

    if [[ $? -eq 0 ]]; then
        print_success "Monitoring setup completed"
    else
        print_error "Monitoring setup failed. Check logs: $LOG_FILE"
        exit 1
    fi
}

# Function to perform health check
health_check() {
    print_status "Performing comprehensive health check..."

    cd "$ANSIBLE_DIR"
    ansible-playbook \
        --inventory inventory/hosts.yml \
        --limit "$TARGET_HOSTS" \
        --extra-vars "target_environment=$ENVIRONMENT" \
        playbooks/health-check.yml \
        --check="$DRY_RUN" \
        --verbose="$VERBOSE" \
        --timeout="$TIMEOUT" \
        --forks="$PARALLEL_JOBS" \
        >> "$LOG_FILE" 2>&1

    if [[ $? -eq 0 ]]; then
        print_success "Health check passed"
    else
        print_error "Health check failed. Check logs: $LOG_FILE"
        exit 1
    fi
}

# Function to apply cost optimization
cost_optimize() {
    print_status "Applying cost optimization settings..."

    EXTRA_VARS="target_environment=$ENVIRONMENT,cost_optimization=true"

    cd "$ANSIBLE_DIR"
    ansible-playbook \
        --inventory inventory/hosts.yml \
        --limit "$TARGET_HOSTS" \
        --extra-vars "$EXTRA_VARS" \
        playbooks/cost-optimization.yml \
        --check="$DRY_RUN" \
        --verbose="$VERBOSE" \
        --timeout="$TIMEOUT" \
        --forks="$PARALLEL_JOBS" \
        >> "$LOG_FILE" 2>&1

    if [[ $? -eq 0 ]]; then
        print_success "Cost optimization applied successfully"
    else
        print_error "Cost optimization failed. Check logs: $LOG_FILE"
        exit 1
    fi
}

# Function to send notification
send_notification() {
    if [[ -z "$NOTIFICATION_WEBHOOK" ]]; then
        return 0
    fi

    local message="$1"
    local status="$2"

    curl -X POST "$NOTIFICATION_WEBHOOK" \
        -H "Content-Type: application/json" \
        -d "{
            \"text\": \"$message\",
            \"status\": \"$status\",
            \"environment\": \"$ENVIRONMENT\",
            \"version\": \"$DEPLOYMENT_VERSION\",
            \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"
        }" \
        --silent --show-error >> "$LOG_FILE" 2>&1
}

# Function to cleanup
cleanup() {
    print_status "Performing cleanup..."

    # Remove temporary files
    rm -f /tmp/ansible-ssh-* 2>/dev/null || true
    
    # Cleanup old logs (keep last 10)
    find "$LOG_DIR" -name "ansible-deploy-*.log" -type f -printf '%T@ %p\n' | \
        sort -n | head -n -10 | cut -d' ' -f2- | xargs rm -f 2>/dev/null || true

    print_success "Cleanup completed"
}

# Main execution
main() {
    local command=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            deploy|update|monitor|backup|rollback|health-check|cost-optimize)
                command="$1"
                shift
                ;;
            -e|--environment)
                ENVIRONMENT="$2"
                shift 2
                ;;
            -v|--version)
                DEPLOYMENT_VERSION="$2"
                shift 2
                ;;
            -h|--hosts)
                TARGET_HOSTS="$2"
                shift 2
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -V|--verbose)
                VERBOSE=true
                shift
                ;;
            -s|--skip-backup)
                SKIP_BACKUP=true
                shift
                ;;
            -m|--skip-monitoring)
                SKIP_MONITORING=true
                shift
                ;;
            -w|--webhook)
                NOTIFICATION_WEBHOOK="$2"
                shift 2
                ;;
            -c|--cost-optimize)
                COST_OPTIMIZATION=true
                shift
                ;;
            -r|--resource-limits)
                RESOURCE_LIMITS=true
                shift
                ;;
            -a|--auto-scaling)
                AUTO_SCALING=true
                shift
                ;;
            -p|--parallel)
                PARALLEL_JOBS="$2"
                shift 2
                ;;
            -t|--timeout)
                TIMEOUT="$2"
                shift 2
                ;;
            --help)
                usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done

    # Validate command
    if [[ -z "$command" ]]; then
        print_error "No command specified"
        usage
        exit 1
    fi

    # Set default target hosts if not specified
    if [[ -z "$TARGET_HOSTS" ]]; then
        TARGET_HOSTS="$ENVIRONMENT"
    fi

    # Start deployment
    print_status "Starting Customer Service Agent deployment..."
    print_status "Command: $command"
    print_status "Environment: $ENVIRONMENT"
    print_status "Version: $DEPLOYMENT_VERSION"
    print_status "Target hosts: $TARGET_HOSTS"
    print_status "Log file: $LOG_FILE"

    # Validate prerequisites
    validate_prerequisites

    # Setup environment
    setup_environment

    # Execute command
    case "$command" in
        "deploy")
            create_backup
            deploy_application
            setup_monitoring
            health_check
            send_notification "Customer Service Agent deployed successfully to $ENVIRONMENT" "success"
            ;;
        "update")
            create_backup
            rolling_update
            health_check
            send_notification "Customer Service Agent updated successfully to $DEPLOYMENT_VERSION" "success"
            ;;
        "monitor")
            setup_monitoring
            send_notification "Monitoring setup completed for $ENVIRONMENT" "success"
            ;;
        "backup")
            create_backup
            send_notification "Backup completed for $ENVIRONMENT" "success"
            ;;
        "health-check")
            health_check
            send_notification "Health check completed for $ENVIRONMENT" "success"
            ;;
        "cost-optimize")
            cost_optimize
            send_notification "Cost optimization applied to $ENVIRONMENT" "success"
            ;;
        *)
            print_error "Unknown command: $command"
            usage
            exit 1
            ;;
    esac

    # Cleanup
    cleanup

    print_success "Deployment script completed successfully!"
    print_status "Check logs for details: $LOG_FILE"
}

# Trap to handle script interruption
trap 'print_error "Script interrupted. Cleaning up..."; cleanup; exit 1' INT TERM

# Execute main function
main "$@" 